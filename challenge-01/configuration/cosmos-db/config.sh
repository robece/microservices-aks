#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "*********************Challenge-01********************"
echo "**********************CosmosDB***********************"
echo "*****************************************************"

# variables

CosmosDBAccountName=""
CosmosDBResourceGroupName=""
CosmosDBDatabaseName=""
CosmosDBConnectionString=""

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

ConfigureCosmosDB ()
{
    read -p "Introduce a lowercase unique name for the new CosmosDB account (max length of 10 chars, is possible to mix lowercase letters from a–z and numbers from 1-10): " CosmosDBAccountName
    read -p "Introduce a lowercase unique name for the new CosmosDB database name (max length of 10 chars, is possible to mix lowercase letters from a–z and numbers from 1-10): " CosmosDBDatabaseName
    read -p "Introduce the name of the resource group previously created for the challenge resources: " CosmosDBResourceGroupName
    
    CreateCosmosDBAccount
}

CreateCosmosDBAccount ()
{  
    # create cosmosdb account
    az cosmosdb create --name $CosmosDBAccountName \
        --resource-group $CosmosDBResourceGroupName \
        --default-consistency-level Session \
        --kind MongoDB

    # create cosmosdb database
    az cosmosdb mongodb database create --account-name $CosmosDBAccountName --name $CosmosDBDatabaseName --resource-group $CosmosDBResourceGroupName

    # get connection string
    CosmosDBConnectionString=$(az cosmosdb list-connection-strings --name $CosmosDBAccountName --resource-group $CosmosDBResourceGroupName --query "[connectionStrings][0][0].connectionString" -o tsv)

    echo ""
    echo "Congratulations!! the CosmosDB resource is ready to be used"
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
    echo "Take note of the ConnectionString: "$CosmosDBConnectionString
    echo "Take note of the CosmosDBAccount: "$CosmosDBAccountName
    echo "Take note of the DatabaseId: "$CosmosDBDatabaseName
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
}

Configure ()
{
    # configure CosmosDB
    ConfigureCosmosDB
     
    #more code here
    exit 0
}

ConfigureAzureSubscription