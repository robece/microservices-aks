#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "******************Container Registry*****************"
echo "*****************************************************"

# variables for Key Vault Configuration

ACRName=""
ACRResourceGroupName=""
ACRResourceGroupLocation=""
ACRUsername=""
ACRPassword=""

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

ConfigureACR ()
{
    read -p "Introduce a lowercase unique name for your new Container Registry (e.g. myuniqueacr01): " ACRName
    read -p "Introduce a lowercase unique name for your new Container Registry resource group (e.g. myuniqueacr01-rg): " ACRResourceGroupName
    
    ConfigureACRLocation
}

ConfigureACRLocation ()
{
    echo "Introduce the location of your new resource group: "

    echo "1) Australia East     -> australiaeast"
    echo "2) Central US         -> centralus"
    echo "3) East US            -> eastus"
    echo "4) East US 2          -> eastus2"
    echo "5) Japan East         -> japaneast"
    echo "6) North Europe       -> northeurope"
    echo "7) Southeast Asia     -> southeastasia"
    echo "8) West Central US    -> westcentralus"
    echo "9) West Europe        -> westeurope"
    echo "10) West US           -> westus"
    echo "11) West US 2         -> westus2"
    echo "12) South Central US  -> southcentralus"
    read -p "Select the number of the preferred location: " ACRResourceGroupLocation

    # all to lower case
    ACRResourceGroupLocation=$(echo $ACRResourceGroupLocation | awk '{print tolower($0)}')

    # check and act on given answer
    case $ACRResourceGroupLocation in
        "1")  CreateACR "australiaeast" ;;
        "2")  CreateACR "centralus" ;;
        "3")  CreateACR "eastus" ;;
        "4")  CreateACR "eastus2" ;;
        "5")  CreateACR "japaneast" ;;
        "6")  CreateACR "northeurope" ;;
        "7")  CreateACR "southeastasia" ;;
        "8")  CreateACR "westcentralus" ;;
        "9")  CreateACR "westeurope" ;;
        "10") CreateACR "westus" ;;
        "11") CreateACR "westus2" ;;
        "12") CreateACR "southcentralus" ;;
        *)    echo "Please select a valid location" ; ConfigureACRLocation ;;
    esac
}

CreateACR ()
{
    ACRResourceGroupLocation=$1
   
    # create resource group
    az group create --name $ACRResourceGroupName --location $ACRResourceGroupLocation

    # create container registry
    az acr create -n $ACRName -g $ACRResourceGroupName --sku Standard

    # update admin privileges
    az acr update -n $ACRName --admin-enabled true

    # get registry username
    ACRUsername=$(az acr credential show -n $ACRName -g $ACRResourceGroupName --query username -o tsv)

    # get registry password
    ACRPassword=$(az acr credential show -n $ACRName -g $ACRResourceGroupName --query passwords[0].value -o tsv)

    echo ""
    echo "Congratulations!! your Container Registry resource is ready to be used"
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
    echo "Take note of the RegistryName: "$ACRName
    echo "Take note of the RegistryUsername: "$ACRUsername
    echo "Take note of the RegistryPassword: "$ACRPassword
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
}

Configure ()
{
    # configure ACR
    ConfigureACR
     
    #more code here
    exit 0
}

ConfigureAzureSubscription