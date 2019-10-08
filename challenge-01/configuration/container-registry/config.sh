#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "*********************Challenge-01********************"
echo "******************Container Registry*****************"
echo "*****************************************************"

# variables

ACRName=""
ACRResourceGroupName=""
ACRUsername=""
ACRPassword=""

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

ConfigureACR ()
{
    read -p "Introduce a unique name for the new Container Registry (max length of 10 chars, is possible to mix lowercase letters from a–z and numbers from 1-10): " ACRName
    read -p "Introduce the name of the resource group previously created for the challenge resources: " ACRResourceGroupName

    CreateACR
}

CreateACR ()
{
    # create container registry
    az acr create -n $ACRName -g $ACRResourceGroupName --sku Standard

    # update admin privileges
    az acr update -n $ACRName --admin-enabled true

    # get registry username
    ACRUsername=$(az acr credential show -n $ACRName -g $ACRResourceGroupName --query username -o tsv)

    # get registry password
    ACRPassword=$(az acr credential show -n $ACRName -g $ACRResourceGroupName --query passwords[0].value -o tsv)

    echo ""
    echo "Congratulations!! the Container Registry resource is ready to be used"
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