#!/bin/bash

clear
echo "*****************************************************"
echo "******************Microservices-AKS******************"
echo "*********************Challenge-01********************"
echo "**********************Key Vault**********************"
echo "*****************************************************"

# variables

KeyVaultClientSecretPassword="33CD7FE44B9BD2070EF8356F069A464!"
KeyVaultAccountName=""
KeyVaultResourceGroupName=""
KeyVaultCertificateName=""
KeyVaultApplicationAppId=""
KeyVaultEncryptionKey="88CD7FE44B9BD2070EF8356F069A4647"

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

ConfigureKeyVault ()
{
    read -p "Introduce a lowercase unique name for the new Key Vault account (max length of 10 chars, is possible to mix lowercase letters from a–z and numbers from 1-10): " KeyVaultAccountName
    read -p "Introduce the name of the resource group previously created for the challenge resources: " KeyVaultResourceGroupName

    CreateKeyVaultAccount
}

CreateKeyVaultAccount ()
{   
    # create service principal to key vault
    az ad sp create-for-rbac -n $KeyVaultAccountName

    # get service principal id
    KeyVaultApplicationAppId=$(az ad sp list --display-name $KeyVaultAccountName --query "[].appId" -o tsv)
 
    # update the AAD application
    az ad app update --id $KeyVaultApplicationAppId \
    --reply-urls "http://localhost" --credential-description "CLIENT_SECRET" \
    --password $KeyVaultClientSecretPassword --oauth2-allow-implicit-flow false

    # create key vault account
    az keyvault create --name $KeyVaultAccountName \
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
    echo "Congratulations!! the Key Vault resource is ready to be used"
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