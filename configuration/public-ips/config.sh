#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "*********************Public IPs**********************"
echo "*****************************************************"

# variables for Key Vault Configuration

AKSCluster=""
AKSClusterResourceGroup=""
AKSClusterNodeResourceGroup=""
PublicIPRabbit=""
PublicIPAPI=""
PublicIPWebsite=""

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

ConfigurePublicIPs ()
{
    read -p "Introduce the name of your Kubernetes Service Cluster: " AKSCluster
    read -p "Introduce the name of your Kubernetes Service Cluster Resource Group: " AKSClusterResourceGroup

    CreateKeyVaultAccount
}

CreateKeyVaultAccount ()
{
    # get node resource group
    AKSClusterNodeResourceGroup=$(az aks show --resource-group $AKSClusterResourceGroup --name $AKSCluster --query nodeResourceGroup -o tsv)
   
    # wait 30 seconds for change propagation
    sleep 30

    # create ip for rabbitmq service
    az network public-ip create \
    --resource-group $AKSClusterNodeResourceGroup \
    --name rabbitmq \
    --allocation-method static

    # wait 30 seconds for change propagation
    sleep 30

    # get rabbit public ip
    PublicIPRabbit=$(az network public-ip show --resource-group $AKSClusterNodeResourceGroup --name rabbitmq --query ipAddress --output tsv)

    # create ip for api service
    az network public-ip create \
    --resource-group $AKSClusterNodeResourceGroup \
    --name api \
    --allocation-method static

    # wait 30 seconds for change propagation
    sleep 30

    # get api public ip
    PublicIPAPI=$(az network public-ip show --resource-group $AKSClusterNodeResourceGroup --name api --query ipAddress --output tsv)

    # create ip for api service
    az network public-ip create \
    --resource-group $AKSClusterNodeResourceGroup \
    --name website \
    --allocation-method static

    # wait 30 seconds for change propagation
    sleep 30

    # get website public ip
    PublicIPWebsite=$(az network public-ip show --resource-group $AKSClusterNodeResourceGroup --name website --query ipAddress --output tsv)

    echo ""
    echo "Congratulations!! your Public IPs resources are ready to be used"
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
    echo "Take note of the Public IP for Rabbit Service: "$PublicIPRabbit
    echo "Take note of the Public IP for API Service: "$PublicIPAPI
    echo "Take note of the Public IP for Website: "$PublicIPWebsite
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
}

Configure ()
{
    # configure Public IPs
    ConfigurePublicIPs
     
    #more code here
    exit 0
}

ConfigureAzureSubscription