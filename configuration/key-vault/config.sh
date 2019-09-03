#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "**********************Key Vault**********************"
echo "*****************************************************"

# variables for Key Vault Configuration

KeyVaultClientSecretPassword="33CD7FE44B9BD2070EF8356F069A464!"
KeyVaultAccountName=""
KeyVaultResourceGroupName=""
KeyVaultResourceGroupLocation=""
KeyVaultCertificateName=""
KeyVaultApplicationAppId=""
KeyVaultEncryptionKey="88CD7FE44B9BD2070EF8356F069A4647"

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

ConfigureKeyVault ()
{
    read -p "Introduce a lowercase unique name for your new Key Vault account (e.g. myuniquekeyvault01): " KeyVaultAccountName
    read -p "Introduce a lowercase unique name for your new Key Vault resource group (e.g. myuniquekeyvault01-rg): " KeyVaultResourceGroupName

    ConfigureKeyVaultLocation
}

ConfigureKeyVaultLocation ()
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
    read -p "Select the number of the preferred location: " KeyVaultResourceGroupLocation

    # all to lower case
    KeyVaultResourceGroupLocation=$(echo $KeyVaultResourceGroupLocation | awk '{print tolower($0)}')

    # check and act on given answer
    case $KeyVaultResourceGroupLocation in
        "1")  CreateKeyVaultAccount "australiaeast" ;;
        "2")  CreateKeyVaultAccount "centralus" ;;
        "3")  CreateKeyVaultAccount "eastus" ;;
        "4")  CreateKeyVaultAccount "eastus2" ;;
        "5")  CreateKeyVaultAccount "japaneast" ;;
        "6")  CreateKeyVaultAccount "northeurope" ;;
        "7")  CreateKeyVaultAccount "southeastasia" ;;
        "8")  CreateKeyVaultAccount "westcentralus" ;;
        "9")  CreateKeyVaultAccount "westeurope" ;;
        "10") CreateKeyVaultAccount "westus" ;;
        "11") CreateKeyVaultAccount "westus2" ;;
        "12") CreateKeyVaultAccount "southcentralus" ;;
        *)    echo "Please select a valid location" ; ConfigureKeyVaultLocation ;;
    esac
}

CreateKeyVaultAccount ()
{
    KeyVaultResourceGroupLocation=$1
   
    # create service principal to key vault
    az ad sp create-for-rbac -n $KeyVaultAccountName

    # get service principal id
    KeyVaultApplicationAppId=$(az ad sp list --display-name $KeyVaultAccountName --query "[].appId" -o tsv)
 
    # update the AAD application
    az ad app update --id $KeyVaultApplicationAppId \
    --reply-urls "http://localhost" --credential-description "CLIENT_SECRET" \
    --password $KeyVaultClientSecretPassword --oauth2-allow-implicit-flow false

    # create resource group
    az group create --name $KeyVaultResourceGroupName --location $KeyVaultResourceGroupLocation

    # create key vault account
    az keyvault create --location $KeyVaultResourceGroupLocation --name $KeyVaultAccountName \
        --resource-group $KeyVaultResourceGroupName --sku standard
    
    # adding secret for encryption
    az keyvault secret set --name "ENCRYPTION-KEY" --vault-name $KeyVaultAccountName --value $KeyVaultEncryptionKey

    # add key vault certificate 
    KeyVaultCertificateName=$KeyVaultAccountName"-cert"

    # create a Key Vault certificate
    az keyvault certificate create --vault-name $KeyVaultAccountName --name $KeyVaultCertificateName  -p "$(az keyvault certificate get-default-policy)"

    # add policy to Key Vault account
    az keyvault set-policy --name $KeyVaultAccountName --spn $KeyVaultApplicationAppId \
        --secret-permissions get list set delete recover backup restore

    echo ""
    echo "Congratulations!! your Key Vault resource is ready to be used"
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
    echo "Take note of the KeyVaultCertificateName: "$KeyVaultCertificateName
    echo "Take note of the KeyVaultClientId: "$KeyVaultApplicationAppId
    echo "Take note of the KeyVaultClientSecret: "$KeyVaultClientSecretPassword
    echo "Take note of the KeyVaultIdentifier: https://"$KeyVaultAccountName".vault.azure.net"
    echo "Take note of the KeyVaultEncryptionKey: ENCRYPTION-KEY"
    echo ""
    echo "****************************CALL TO ACTION****************************"
    echo ""
}

Configure ()
{
    # configure Key Vault
    ConfigureKeyVault
     
    #more code here
    exit 0
}

ConfigureAzureSubscription