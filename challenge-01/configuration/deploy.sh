#!/bin/bash
clear

# NOTE: before run this script ensure you are logged in Azure by using az login command.

read -p "Introduce a lowercase unique alias for your deployment (max length suggested of 6 chars): " DeploymentAlias
read -p "Introduce your email address in lowercase for your deployment: " EmailAddress
RandomId=$(echo $(( ( RANDOM % 99 )  + 1 )))
ResourceGroupName=$DeploymentAlias"-microservices-aks-c01"
Location="westus2"
AKSClusterName=$DeploymentAlias"aks"$RandomId
AKSK8sVersion="1.14.8"
ContainerRegistryName=$DeploymentAlias"cr"$RandomId
CosmosDBAccountName=$DeploymentAlias"cos"$RandomId
CosmosDBDatabaseName=$DeploymentAlias"db"$RandomId
KeyVaultAccountName=$DeploymentAlias"kv"$RandomId
KeyVaultClientSecretPassword="33CD7FE44B9BD2070EF8356F069A464!"
KeyVaultEncryptionKey="88CD7FE44B9BD2070EF8356F069A4647"
SendGridAccountName=$DeploymentAlias"sg"$RandomId
SendGridPassword="33CD7FE44B9BD2070EF8356F069A464!"
SendGridEmailCreator=$EmailAddress
SendGridFirstnameCreator="guest"
SendGridLastnameCreator="guest"
SendGridCompanyCreator="guest"
SendGridWebsiteCreator="http://guest.com"
ServicePrincipal=$DeploymentAlias"-microservices-aks-c01-sp"

# PRINT
echo "*******************************************"
echo "        CREATING: SERVICE PRINCIPAL"
echo "*******************************************"

echo "Creating service principal ..."
az ad sp create-for-rbac -n $ServicePrincipal

# get app id
SP_APP_ID=$(az ad sp show --id http://$ServicePrincipal --query appId -o tsv)
echo "Service Principal AppId: "$SP_APP_ID

# updating password
SP_APP_PASSWORD=$(az ad sp credential reset --name $ServicePrincipal --query password -o tsv)
echo "Service Principal Password: "$SP_APP_PASSWORD

# PRINT
echo "*******************************************"
echo "   CREATING: GENERAL RESOURCE GROUP"
echo "*******************************************"

# create cluster resource group
az group create --name $ResourceGroupName --location $Location

# get group id
GROUP_ID=$(az group show -n $ResourceGroupName --query id -o tsv)

# role assignment 
az role assignment create --assignee $SP_APP_ID --scope $GROUP_ID --role "Contributor"

# PRINT
echo "*******************************************"
echo "       CREATING: CONTAINER REGISTRY"
echo "*******************************************"

# create acr
az acr create -n $ContainerRegistryName -g $ResourceGroupName --sku basic --admin-enabled true

# get container registry id
ContainerRegistryId=$(az acr show -n $ContainerRegistryName -g $ResourceGroupName --query id -o tsv)

# get acr id 
ACR_ID=$(az acr show -n $ContainerRegistryName -g $ResourceGroupName --query id -o tsv)

# role assignment 
az role assignment create --assignee $SP_APP_ID --scope $ACR_ID --role "Contributor"

# PRINT
echo "*******************************************"
echo "        CREATING: AKS CLUSTER"
echo "*******************************************"

# create cluster
az aks create \
    --name $AKSClusterName \
    --resource-group $ResourceGroupName \
    --node-count 1 \
    --kubernetes-version $AKSK8sVersion \
    --service-principal $SP_APP_ID \
    --client-secret $SP_APP_PASSWORD \
    --generate-ssh-keys

# update cluster
az aks update \
    --resource-group $ResourceGroupName \
    --name $AKSClusterName \
    --attach-acr $ContainerRegistryId

# get registry username
ContainerRegistryUsername=$(az acr credential show -n $ContainerRegistryName -g $ResourceGroupName --query username -o tsv)

# get registry password
ContainerRegistryPassword=$(az acr credential show -n $ContainerRegistryName -g $ResourceGroupName --query passwords[0].value -o tsv)

# PRINT
echo "*******************************************"
echo "          CREATING: COSMOSDB"
echo "*******************************************"

# create cosmosdb account
az cosmosdb create --name $CosmosDBAccountName \
    --resource-group $ResourceGroupName \
    --default-consistency-level Session \
    --kind MongoDB

# create cosmosdb database
az cosmosdb mongodb database create --account-name $CosmosDBAccountName --name $CosmosDBDatabaseName --resource-group $ResourceGroupName

# get primary key
CosmosDBPrimaryKey=$(az cosmosdb keys list --name $CosmosDBAccountName --resource-group $ResourceGroupName --query "primaryMasterKey" -o tsv)
CosmosDBConnectionString="mongodb://"$CosmosDBAccountName":"$CosmosDBPrimaryKey"@"$CosmosDBAccountName".documents.azure.com:10255/?ssl=true&replicaSet=globaldb"

# PRINT
echo "*******************************************"
echo "          CREATING: KEY VAULT"
echo "*******************************************"

# update the AAD application
az ad app update --id $SP_APP_ID \
--reply-urls "http://localhost" --credential-description "CLIENT_SECRET" \
--password $KeyVaultClientSecretPassword --oauth2-allow-implicit-flow false

# create key vault account
az keyvault create --name $KeyVaultAccountName \
    --resource-group $ResourceGroupName --sku standard

# adding secret for encryption
az keyvault secret set --name "ENCRYPTION-KEY" --vault-name $KeyVaultAccountName --value $KeyVaultEncryptionKey

# add key vault certificate 
KeyVaultCertificateName=$KeyVaultAccountName"-cert"

# create a Key Vault certificate
az keyvault certificate create --vault-name $KeyVaultAccountName --name $KeyVaultCertificateName  -p "$(az keyvault certificate get-default-policy)"

# add policy to Key Vault account
az keyvault set-policy --name $KeyVaultAccountName --spn $SP_APP_ID \
    --secret-permissions get list set delete recover backup restore

# PRINT
echo "*******************************************"
echo "          CREATING: SENDGRID"
echo "*******************************************"

# accept terms
az vm image terms accept --publisher Sendgrid --offer sendgrid_azure --plan free

# create a deployment from a local template, using a local parameter file, a remote parameter file, and selectively overriding key/value pairs
az deployment group create -g $ResourceGroupName --template-file sendgrid.json \
--parameters @sendgrid-parameters.json --parameters name=$SendGridAccountName location=$Location password=$SendGridPassword email=$SendGridEmailCreator firstName=$SendGridFirstnameCreator lastName=$SendGridLastnameCreator company=$SendGridCompanyCreator website=$SendGridWebsiteCreator

echo ""
echo "****************************CALL TO ACTION****************************"
echo ""
echo "Take note of the KubernetesCluster: "$AKSClusterName
echo "Take note of the KubernetesClusterResourceGroup: "$ResourceGroupName
echo "Take note of the RegistryName: "$ContainerRegistryName
echo "Take note of the RegistryUsername: "$ContainerRegistryUsername
echo "Take note of the RegistryPassword: "$ContainerRegistryPassword
echo "Take note of the ConnectionString: "$CosmosDBConnectionString
echo "Take note of the CosmosDBAccount: "$CosmosDBAccountName
echo "Take note of the DatabaseId: "$CosmosDBDatabaseName
echo "Take note of the KeyVaultCertificateName: "$KeyVaultCertificateName
echo "Take note of the KeyVaultClientId: "$KeyVaultApplicationAppId
echo "Take note of the KeyVaultClientSecret: "$KeyVaultClientSecretPassword
echo "Take note of the KeyVaultIdentifier: https://"$KeyVaultAccountName".vault.azure.net"
echo "Take note of the KeyVaultEncryptionKey: ENCRYPTION-KEY"
echo "Take note of the ServicePrincipal: http://"$ServicePrincipal
echo "Take note of the ServicePrincipalPassword: "$SP_APP_PASSWORD
echo ""
echo "****************************CALL TO ACTION****************************"