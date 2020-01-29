#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "*********************Challenge-01********************"
echo "************Azure Kubernetes Service(AKS)************"
echo "*****************************************************"

# variables

AKSResourceGroupName=""
AKSClusterName=""
AKSVirtualNodes="no"
AKSClusterNodes="0"
AKSClusterVMSize=""
AKSClusterServicePrincipalAppId=""
AKSClusterServicePrincipalPassword=""

ConfigureAzureSubscription ()
{
    # authenticate to azure suscription
    az login
  
    echo "Validate the default subscription to work:"
    az account list

    read -p "Copy and paste the id of the validated subscription to work: " subscriptionId
    az account set --subscription $subscriptionId

    echo "The subscription selected is: "
    az account show

    read -p "Is that correct? (yes/no): " answer

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
    read -p "Introduce a lowercase unique name for the new AKS cluster (max length of 10 chars, is possible to mix lowercase letters from a–z and numbers from 1-10): " AKSClusterName
    read -p "Introduce the name of the resource group previously created for the challenge resources: " AKSResourceGroupName
    read -p "Introduce the number of nodes in the cluster: " AKSClusterNodes
    read -p "Introduce the VM size for the nodes (e.g. Standard_D2s_v3): " AKSClusterVMSize

    ConfigureAKSCluster
}

ConfigureAKSCluster ()
{
    # create service principal to cluster
    az ad sp create-for-rbac -n $AKSClusterName

    # get service principal id
    AKSClusterServicePrincipalAppId=$(az ad sp list --display-name $AKSClusterName --query "[].appId" -o tsv)
    
    # reset service principal password
    AKSClusterServicePrincipalPassword=$(az ad sp credential reset --name $AKSClusterName --query password -o tsv)

    # wait 2 minutes for propagation
    sleep 2m

    # create aks cluster
    az aks create \
    --resource-group $AKSResourceGroupName \
    --name $AKSClusterName \
    --node-count $AKSClusterNodes \
    --node-vm-size $AKSClusterVMSize \
    --generate-ssh-keys \
    --service-principal $AKSClusterServicePrincipalAppId \
    --client-secret $AKSClusterServicePrincipalPassword \
    --enable-vmss \
    --kubernetes-version 1.13.12

    # download .kube config to client machine
    az aks get-credentials --resource-group $AKSResourceGroupName --name $AKSClusterName

    # assign permissions to dashboard
    kubectl create clusterrolebinding kubernetes-dashboard -n kube-system --clusterrole=cluster-admin --serviceaccount=kube-system:kubernetes-dashboard

    echo ""
    echo "Congratulations!! the Kubernetes Service resource is ready to be used"
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