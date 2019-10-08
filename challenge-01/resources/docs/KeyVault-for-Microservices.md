## Azure Key Vault for Microservices

Azure Key Vault is one of the most important pieces in the solution, providing storage to the secrets used for encryption, RabbitMQ use an Azure Key Vault secret key to encrypt all messages stored in queues and the console messages processor use the same secret key to decrypt and process messages.

Create a new Azure Key Vault, if you don't know how to create the resource check this: https://docs.microsoft.com/en-us/azure/key-vault/quick-create-portal.

For the Challenge 1, there are three important pieces in the Azure Key Vault resource configuration:

- Certificates
- Secrets
- Access Policies

## Create a Certificate

Go to the Key Vault resource, click Certificates and Generate/Import, then write the certificate name and subject and click create.

<div style="text-align:center">
    <img src="/challenge-01/resources/images/azure-key-vault-add-certificate.png" />
</div>

Once you click create, the new certificate will appear and this will be the <b>KeyVaultCertificateName</b> for the application.

<div style="text-align:center">
    <img src="/challenge-01/resources/images/azure-key-vault-certificates.png" />
</div>

## Get the Key Vault DNS

Go to the Key Vault resource, click Overview and copy the DNS Name this will be the <b>KeyVaultIdentifier</b> for the application.

## Create a Secret

Go to the Key Vault resource, click Secrets and add:

- Name: KEYVAULT_SECRET
- Value: 33CD7FE44B9BD2070EF8356F069A4647

Once the Azure resource has been created add the <b>KeyVaultEncryptionKey</b> secret.

## Create Azure AAD Application for Key Vault

Go to Azure Active Directory resource and click in App Registrations, then click in New application registration, fill the fields and click create.

<div style="text-align:center">
    <img src="/challenge-01/resources/images/azure-active-directory-app-registration.png" width="300" />
</div>

Take note of Application ID, this will be the <b>KeyVaultClientId</b> for the application.

<div style="text-align:center">
    <img src="/challenge-01/resources/images/azure-active-directory-app-overview.png" width="500" />
</div>

Now let's configure the Key settings.

Click Settings then Keys, add the following fields and save it.

- DESCRIPTION: CLIENT_SECRET
- EXPIRES: Never expires 

<div style="text-align:center">
    <img src="/challenge-01/resources/images/azure-active-directory-app-key-setting.png" />
</div>

Once the key is saved a value will appear, take note of this value because we are going to use it later in the <b>KeyVaultClientSecret</b> in the application.

<div style="text-align:center">
    <img src="/challenge-01/resources/images/azure-active-directory-app-key-setting-value.png" />
</div>

## Link AAD Application with Azure Key Vault 

Go to the Key Vault resource, click Access policies and add new.

<div style="text-align:center">
    <img src="/challenge-01/resources/images/azure-key-vault-access-policies.png" />
</div>

Select the AAD Application and click Ok.

<div style="text-align:center">
    <img src="/challenge-01/resources/images/azure-key-vault-new-access-policy.png" />
</div>

The application will use the following Secret Permissions:
Get, List, Set, Delete, Recover, Backup, Restore.

Once the new access policy is created the Azure Key Vault account is ready to work with the microservices.