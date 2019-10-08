#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "*********************Challenge-01********************"
echo "**********************SendGrid***********************"
echo "*****************************************************"

# variables

SendGridAccountName=""
SendGridResourceGroupName=""
SendGridResourceGroupLocation=""
SendGridPassword="33CD7FE44B9BD2070EF8356F069A464!"
SendGridEmailCreator=""
SendGridFirstnameCreator=""
SendGridLastnameCreator=""

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

ConfigureSendGrid ()
{
    read -p "Introduce a lowercase unique name for the new SendGrid account (max length of 10 chars, is possible to mix lowercase letters from a–z and numbers from 1-10): " SendGridAccountName
    read -p "Introduce the name of the resource group previously created for the challenge resources: " SendGridResourceGroupName
    read -p "Introduce the location of the resource group previously created for the challenge resources: " SendGridResourceGroupLocation
    read -p "Introduce a lowercase creator's email: " SendGridEmailCreator
    read -p "Introduce a lowercase creator's first name: " SendGridFirstnameCreator
    read -p "Introduce a lowercase creator's lastname: " SendGridLastnameCreator
    
    CreateSendGridAccount
}

CreateSendGridAccount ()
{
    # create a deployment from a local template, using a local parameter file, a remote parameter file, and selectively overriding key/value pairs
    az group deployment create -g $SendGridResourceGroupName --template-file deployment.json \
    --parameters @parameters.json --parameters name=$SendGridAccountName location=$SendGridResourceGroupLocation password=$SendGridPassword email=$SendGridEmailCreator firstName=$SendGridFirstnameCreator lastName=$SendGridLastnameCreator

    echo ""
    echo "Congratulations!! the SendGrid resource is ready to be used"
    echo ""
}

Configure ()
{
    # configure SendGrid
    ConfigureSendGrid
     
    #more code here
    exit 0
}

ConfigureAzureSubscription