#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "************Azure Kubernetes Service(AKS)************"
echo "*****************************************************"

# variables for AKS Configuration

AKSResourceGroupName=""
AKSResourceGroupLocation=""
AKSClusterName=""
AKSVirtualNodes="no"
AKSClusterNodes="0"
AKSClusterVMSize=""
AKSClusterServicePrincipalAppId=""
AKSClusterServicePrincipalPassword=""
AKSClusterVNETName=""
AKSClusterSubnetName=""
AKSClusterVirtualNodeSubnet=""
AKSClusterVNETId=""
AKSClusterVNETSubnetId=""

ConfigureAzureSubscription ()
{
    # authenticate to azure suscription
    az login
  
    echo "Verify your default subscription where you created the resources:"
    az account list 

    read -p "Copy and paste the id of the subscription where you created the resources: " subscriptionId
    az account set --subscription $subscriptionId

    echo "The subscription you have selected is: "
    az account show

    read -p "In this subscription your previously created the resources, is that correct? (yes/no): " answer

    # all to lower case
    answer=$(echo $answer | awk '{print tolower($0)}')

    # check and act on given answer
    case $answer in
        "yes")  Configure ;;
        *)      echo "Please answer yes or no" ; ConfigureAzureSubscription ;;
    esac
}

ConfigureAKS ()
{
    read -p "Introduce a lowercase unique name for your new AKS cluster (e.g. myuniqueakscluster01): " AKSClusterName
    read -p "Introduce a lowercase unique name for your new AKS resource group (e.g. myuniqueakscluster01-rg): " AKSResourceGroupName
    read -p "Introduce the number of nodes in your cluster: " AKSClusterNodes
    read -p "Introduce the VM size for the nodes (e.g. Standard_D2s_v3): " AKSClusterVMSize

    ConfigureAKSLocation
}

ConfigureAKSLocation ()
{
    echo "Introduce the location of your new resource group: "

    echo "1) Australia East   -> australiaeast"
    echo "2) Central US       -> centralus"
    echo "3) East US          -> eastus"
    echo "4) East US 2        -> eastus2"
    echo "5) Japan East       -> japaneast"
    echo "6) North Europe     -> northeurope"
    echo "7) Southeast Asia   -> southeastasia"
    echo "8) West Central US  -> westcentralus"
    echo "9) West Europe      -> westeurope"
    echo "10) West US         -> westus"
    echo "11) West US 2       -> westus2"

    read -p "Select the number of the preferred location: " AKSResourceGroupLocation

    # all to lower case
    AKSResourceGroupLocation=$(echo $AKSResourceGroupLocation | awk '{print tolower($0)}')

    # check and act on given answer
    case $AKSResourceGroupLocation in
        "1")  ConfigureAKSVirtualNodes "australiaeast" ;;
        "2")  ConfigureAKSVirtualNodes "centralus" ;;
        "3")  ConfigureAKSVirtualNodes "eastus" ;;
        "4")  ConfigureAKSVirtualNodes "eastus2" ;;
        "5")  ConfigureAKSVirtualNodes "japaneast" ;;
        "6")  ConfigureAKSVirtualNodes "northeurope" ;;
        "7")  ConfigureAKSVirtualNodes "southeastasia" ;;
        "8")  ConfigureAKSVirtualNodes "westcentralus" ;;
        "9")  ConfigureAKSVirtualNodes "westeurope" ;;
        "10") ConfigureAKSVirtualNodes "westus" ;;
        "11") ConfigureAKSVirtualNodes "westus2" ;;
        *)    echo "Please select a valid location" ; ConfigureAKSLocation ;;
    esac
}

ConfigureAKSVirtualNodes ()
{
    AKSResourceGroupLocation=$1

    read -p "Do you want to configure AKS with virtual nodes (yes/no): " AKSVirtualNodes

    # all to lower case
    AKSVirtualNodes=$(echo $AKSVirtualNodes | awk '{print tolower($0)}')

    # check and act on given answer
    case $AKSVirtualNodes in
        "yes")  ConfigureAKSVirtualNodesWithVirtualNodes ;;
        "no")  ConfigureAKSVirtualNodesWithoutVirtualNodes ;;
        *)      echo "Please answer yes or no" ; ConfigureAzureSubscription ;;
    esac
}

ConfigureAKSVirtualNodesWithVirtualNodes ()
{
    # validate the service provider with your subscription
    az provider list --query "[?contains(namespace,'Microsoft.ContainerInstance')]" -o table

    # validate the service provider with your subscription
    az provider register --namespace Microsoft.ContainerInstance

    # create resource group
    az group create --name $AKSResourceGroupName --location $AKSResourceGroupLocation

    # add vnet name
    AKSClusterVNETName=$AKSClusterName"-vnet"
    
    # add subnet name
    AKSClusterSubnetName=$AKSClusterName"-subnet"

    # add virtual node subnet
    AKSClusterVirtualNodeSubnet=$AKSClusterName"-virtual-node-subnet"

    # create a virtual network
     az network vnet create \
        --resource-group $AKSResourceGroupName \
        --name $AKSClusterVNETName \
        --address-prefixes 10.0.0.0/8 \
        --subnet-name $AKSClusterSubnetName \
        --subnet-prefix 10.240.0.0/16

    # create a virtual network subnet
    az network vnet subnet create \
        --resource-group $AKSResourceGroupName \
        --vnet-name $AKSClusterVNETName \
        --name $AKSClusterVirtualNodeSubnet \
        --address-prefixes 10.241.0.0/16

    # create service principal to cluster
    az ad sp create-for-rbac -n $AKSClusterName

    # get service principal id
    AKSClusterServicePrincipalAppId=$(az ad sp list --display-name $AKSClusterName --query "[].appId" -o tsv)
    
    # reset service principal password
    AKSClusterServicePrincipalPassword=$(az ad sp credential reset --name $AKSClusterName --query password -o tsv)

    # wait 4 minutes for propagation
    sleep 4m

    # assign vnet id
    AKSClusterVNETId=$(az network vnet show --resource-group $AKSResourceGroupName --name $AKSClusterVNETName --query id -o tsv)

    # assign permissions to the virtual network
    az role assignment create --assignee $AKSClusterServicePrincipalAppId --scope $AKSClusterVNETId --role Contributor

    # assign vnet subnet id
    AKSClusterVNETSubnetId=$(az network vnet subnet show --resource-group $AKSResourceGroupName --vnet-name $AKSClusterVNETName --name $AKSClusterSubnetName --query id -o tsv)

    az aks create \
        --resource-group $AKSResourceGroupName \
        --name $AKSClusterName \
        --node-count $AKSClusterNodes \
        --node-vm-size $AKSClusterVMSize \
        --generate-ssh-keys \
        --network-plugin azure \
        --service-cidr 10.0.0.0/16 \
        --dns-service-ip 10.0.0.10 \
        --docker-bridge-address 172.17.0.1/16 \
        --vnet-subnet-id $AKSClusterVNETSubnetId \
        --service-principal $AKSClusterServicePrincipalAppId \
        --client-secret $AKSClusterServicePrincipalPassword

    # wait 30 seconds for change propagation
    sleep 30

    # enable virtual nodes addon
    az aks enable-addons \
        --resource-group $AKSResourceGroupName \
        --name $AKSClusterName \
        --addons virtual-node \
        --subnet-name $AKSClusterVirtualNodeSubnet

    # download .kube config to client machine
    az aks get-credentials --resource-group $AKSResourceGroupName --name $AKSClusterName

    # assign permissions to dashboard
    kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

    # create the service account and role binding
    kubectl apply -f helm-rbac.yml

    # init helm
    helm init --service-account tiller --node-selectors "beta.kubernetes.io/os"="linux"

    echo ""
    echo "Congratulations!! your Kubernetes Service resource is ready to be used"
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
    echo "Take note of the KubernetesCluster: "$AKSClusterName
    echo "Take note of the KubernetesClusterResourceGroup: "$AKSResourceGroupName
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""

    # open aks dashboard
    az aks browse --resource-group $AKSResourceGroupName --name $AKSClusterName
}

ConfigureAKSVirtualNodesWithoutVirtualNodes ()
{
    # create resource group
    az group create --name $AKSResourceGroupName --location $AKSResourceGroupLocation

    # create service principal to cluster
    az ad sp create-for-rbac -n $AKSClusterName

    # get service principal id
    AKSClusterServicePrincipalAppId=$(az ad sp list --display-name $AKSClusterName --query "[].appId" -o tsv)
    
    # reset service principal password
    AKSClusterServicePrincipalPassword=$(az ad sp credential reset --name $AKSClusterName --query password -o tsv)

    # wait 4 minutes for propagation
    sleep 4m

    # create aks cluster
    az aks create \
    --resource-group $AKSResourceGroupName \
    --name $AKSClusterName \
    --node-count $AKSClusterNodes \
    --node-vm-size $AKSClusterVMSize \
    --generate-ssh-keys \
    --service-principal $AKSClusterServicePrincipalAppId \
    --client-secret $AKSClusterServicePrincipalPassword

    # download .kube config to client machine
    az aks get-credentials --resource-group $AKSResourceGroupName --name $AKSClusterName

    # assign permissions to dashboard
    kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

    # create the service account and role binding
    kubectl apply -f helm-rbac.yml

    # init helm
    helm init --service-account tiller --node-selectors "beta.kubernetes.io/os"="linux"

    echo ""
    echo "Congratulations!! your Kubernetes Service resource is ready to be used"
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
    echo "Take note of the KubernetesCluster: "$AKSClusterName
    echo "Take note of the KubernetesClusterResourceGroup: "$AKSResourceGroupName
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""

    # open aks dashboard
    az aks browse --resource-group $AKSResourceGroupName --name $AKSClusterName
}

Configure ()
{
    # configure AKS
    ConfigureAKS
     
    #more code here
    exit 0
}

ConfigureAzureSubscription