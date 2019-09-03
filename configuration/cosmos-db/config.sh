#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "**********************CosmosDB***********************"
echo "*****************************************************"

# variables for Key Vault Configuration

CosmosDBAccountName=""
CosmosDBResourceGroupName=""
CosmosDBResourceGroupLocation=""
CosmosDBDatabaseName=""
CosmosDBConnectionString=""

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

ConfigureCosmosDB ()
{
    read -p "Introduce a lowercase unique name for your new CosmosDB account (e.g. myuniquecosmosaccount01): " CosmosDBAccountName
    read -p "Introduce a lowercase unique name for your new CosmosDB resource group (e.g. myuniquecosmosaccount01-rg): " CosmosDBResourceGroupName
    read -p "Introduce a lowercase unique name for your new CosmosDB database name (e.g. myuniquecosmosaccount01-db): " CosmosDBDatabaseName
    
    ConfigureCosmosDBLocation
}

ConfigureCosmosDBLocation ()
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
    read -p "Select the number of the preferred location: " CosmosDBResourceGroupLocation

    # all to lower case
    CosmosDBResourceGroupLocation=$(echo $CosmosDBResourceGroupLocation | awk '{print tolower($0)}')

    # check and act on given answer
    case $CosmosDBResourceGroupLocation in
        "1")  CreateCosmosDBAccount "australiaeast" ;;
        "2")  CreateCosmosDBAccount "centralus" ;;
        "3")  CreateCosmosDBAccount "eastus" ;;
        "4")  CreateCosmosDBAccount "eastus2" ;;
        "5")  CreateCosmosDBAccount "japaneast" ;;
        "6")  CreateCosmosDBAccount "northeurope" ;;
        "7")  CreateCosmosDBAccount "southeastasia" ;;
        "8")  CreateCosmosDBAccount "westcentralus" ;;
        "9")  CreateCosmosDBAccount "westeurope" ;;
        "10") CreateCosmosDBAccount "westus" ;;
        "11") CreateCosmosDBAccount "westus2" ;;
        "12") CreateCosmosDBAccount "southcentralus" ;;
        *)    echo "Please select a valid location" ; ConfigureCosmosDBLocation ;;
    esac
}

CreateCosmosDBAccount ()
{
    CosmosDBResourceGroupLocation=$1
   
    # create resource group
    az group create --name $CosmosDBResourceGroupName --location $CosmosDBResourceGroupLocation

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
    echo "Congratulations!! your CosmosDB resource is ready to be used"
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