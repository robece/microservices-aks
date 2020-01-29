# Challenge 1

Microservices CI/CD on Azure Kubernetes Service challenge is designed to foster learning via implementing Cloud Native DevOps practices with a series of steps, the sample solution is based on .NET Core microservices presented as containerized services on Azure Kubernetes Services and Azure DevOps Pipelines.

## Services

The solution is splitted in the following services:

- Reporting Service Website (.NET Core 3.0)
- Reporting Service API (.NET Core 3.0)
- Reporting Service Queue (RabbitMQ)
- Reporting Service Processor (.NET Core 3.0)

## Technology Stack 

Azure Cloud Services:
- Container Registry
- CosmosDB (MongoDB)
- Key Vault
- Kubernetes Service
- SendGrid

Advanced Message Queuing Protocol:
- RabbitMQ

Development:
- Docker
- .NET Core

## Prerequisites

1. An active Azure subscription, there are several ways you can procure one:
    * <a href="https://azure.microsoft.com/en-us/free/" target="_blank">Azure Free Account</a>
    * <a href="https://visualstudio.microsoft.com/dev-essentials/" target="_blank">Visual Studio Dev Essentials</a>
    * <a href="https://azure.microsoft.com/en-us/pricing/member-offers/credit-for-visual-studio-subscribers/" target="_blank">Monthly Azure credit for Visual Studio subscribers</a>
2. <a href="https://code.visualstudio.com/" target="_blank">VS Code</a> o <a href="https://visualstudio.microsoft.com/vs/community/" target="_blank">Visual Studio 2019 Community</a>
3. Azure DevOps free account (<a href="https://dev.azure.com/" target="_blank">https://dev.azure.com/</a>)
4. .Net Core 3.0 Installed (<a href="https://www.microsoft.com/net/download" target="_blank">https://www.microsoft.com/net/download</a>)
5. Git for Windows, Linux or MacOS are optional (<a href="https://git-scm.com/downloads" target="_blank">https://git-scm.com/downloads</a>)
6. Docker Desktop (<a href="https://www.docker.com/get-started" target="_blank">https://www.docker.com/get-started</a>). For for older Mac and Windows systems that do not meet the requirements of <a href="https://docs.docker.com/docker-for-mac/" target="_blank">Docker Desktop for Mac</a> and <a href="https://docs.docker.com/docker-for-windows/" target="_blank">Docker Desktop for Windows</a> you could use <a href="https://docs.docker.com/toolbox/toolbox_install_windows/" target="_blank">Docker Toolbox</a>.

## Architecture

<div style="text-align:center">
    <img src="/challenge-01/resources/images/microservices-architecture.png" width="600" />
</div>

<div style="text-align:center">
    <img src="/challenge-01/resources/images/orchestration-architecture.png" width="600" />
</div>

## Leverage Azure DevOps

You could also leverage Azure DevOps to implement a CI/CD pipeline for each app. For that need to create a new Azure build pipeline per app by using the associated yaml definition located in the build-deploy folder.

<div style="text-align:center">
    <img src="/challenge-01/resources/images/devops-ci-cd-pipelines.png" width="600" />
</div>

## First Time?

Is this your first time using Docker?, review the following links:

1. <a href="https://docs.docker.com/get-started/" target="_blank">Docker, get started documentation</a>

Is this your first time using Kubernetes Service?, review the following links:

1. <a href="https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes" target="_blank">Azure Kubernetes Service (AKS)</a>

2. <a href="https://docs.microsoft.com/en-us/azure/aks/concepts-clusters-workloads" target="_blank">Kubernetes core concepts for Azure Kubernetes Service (AKS)</a>

3. <a href="https://azure.microsoft.com/en-us/resources/kubernetes-learning-path/" target="_blank">Kubernetes learning path</a>

Is this your first time using Azure DevOps?, review the following links:

1. <a href="https://docs.microsoft.com/en-us/azure/devops/?view=azure-devops" target="_blank">Azure DevOps documentation</a>

Is this your first time using RabbitMQ?, review the following links:

1. <a href="https://www.rabbitmq.com/dotnet-api-guide.html" target="_blank">RabbitMQ .Net API guide</a>

## Hack Goals

1. The website must be running and needs to be exposed in a specific public ip address.

2. The api must be running and needs to be exposed in a specific cluster ip address.

3. The rabbitmq must be running and needs to be exposed in a specific cluster ip address.

4. The processor must be running it doesn't need any internet exposure with a public ip, but can be monitored using the Kubernetes dashboard.

5. Solution must be working as expected, website sends a request to the API, the API queue a message, the processor dequeue the message then creates a PDF file, save the information in CosmosDB and send the file back to the user who filled the website form.

6. Each application must be deployed in Kubernetes Service as a HELM chart.

7. Each application service must have a CI/CD automated pipeline for build, approve and deploy in Azure DevOps.

8. The Kubernetes Service must be up and running ready for monitoring through the dashboard.

## Let's Hack

Step 1:
- Sign in to Azure DevOps.

    <b>Having issues? </b> review the <a href="https://dev.azure.com" target="_blank">cheat link!</a>

Step 2:
- Create a new project.
    + Version control: Git.
    + Work item process: SCRUM.
    + Visibility: Public | Private.

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops" target="_blank">cheat link!</a>

Step 3:
- Import the GitHub repo into the new Azure DevOps repo.

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/devops/repos/git/import-git-repository?view=azure-devops" target="_blank">cheat link!</a>
    

Step 4:
- Sign in to <a href="https://portal.azure.com" target="_blank">Azure Portal </a> and open the cloud shell bash or use the <a href="https://shell.azure.com/bash" target="_blank">Azure Cloud Shell</a>.

    <b>Having issues? </b> review the <a href="https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/cloud-shell/overview.md" target="_blank">cheat link!</a>


Step 5:
- Using the cloud shell bash clone the GitHub repo.

    ```bash
    git clone https://github.com/robece/microservices-aks.git
    ```

    <b>Having issues? </b> review the <a href="https://help.github.com/en/articles/cloning-a-repository" target="_blank">cheat link!</a>

Step 6:
- Using the cloud shell bash create a new resource group to allocate all the resources of the challenge.

    ```bash
    az group create --name [ResourceGroupName] --location [ResourceGroupLocation]
    ```

    ```bash
    [ResourceGroupName] = name of the resource group e.g. myuniqueresourcegroup01
    [ResourceGroupLocation] = location of the resource group e.g. westus
    ```

    <b>Important:</b> Take note of the [ResourceGroupName] and [ResourceGroupLocation] you may use it later.

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-create" target="_blank">cheat link!</a>

Step 7:
- Create a new container registry resource, for this step you have two options: do it manually or executing the cloud shell bash script located in <b>challenge-01/configuration/container-registry/config.sh</b>.

    <b>Important:</b> In this script you will need to provide:
    
    ```bash
    1. The name of the container registry
    2. The name of the resource group previously created for the challenge resources
    ```

    After the script execution remember to take note of the CALL TO ACTION annotation:

    ```bash
    1. RegistryName
    2. RegistryUsername
    3. RegistryPassword
    ```

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/container-registry/container-registry-get-started-portal" target="_blank">cheat link!</a>

Step 8:
- Create a new CosmosDB resource with the API type: MongoDB, for this step you have two options: do it manually or executing the cloud shell bash script located in <b>challenge-01/configuration/cosmos-db/config.sh</b>.

    <b>Important:</b> In this script you will need to provide:
    
    ```bash
    1. The name of the cosmos db account
    2. The name of the cosmos db database
    3. The name of the resource group previously created for the challenge resources
    ```

    <b>Note:</b> If you want to create or use an existing CosmosDB account just validate that is using the MongoDB API.

    After the script execution remember to take note of the CALL TO ACTION annotation:

    ```bash
    1. ConnectionString
    2. CosmosDBAccount
    3. DatabaseId
    ```

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/cosmos-db/create-cosmosdb-resources-portal" target="_blank">cheat link!</a>
    <br/>

Step 9:
- Create a new Key Vault resource, for this step you have two options: do it manually or executing the cloud shell bash script located in <b>challenge-01/configuration/key-vault/config.sh</b>.

    <b>Important:</b> In this script you will need to provide:
    
    ```bash
    1. The name of the key vault
    2. The name of the resource group previously created for the challenge resources
    ```

    After the script execution remember to take note of the CALL TO ACTION annotation:

    ```bash
    1. KeyVaultCertificateName
    2. KeyVaultClientId
    3. KeyVaultClientSecret
    4. KeyVaultIdentifier
    5. KeyVaultEncryptionKey
    ```

    <b>Having issues? </b> review the <a href="/challenge-01/resources/docs/KeyVault-for-Microservices.md" target="_blank">cheat link!</a>

Step 10:
- Create a new Kubernetes Service resource, for this step you have two options: do it manually or executing the cloud shell bash script located in <b>challenge-01/configuration/kubernetes-service/config.sh</b>.

    <b>Important:</b> In this script you will need to provide:
    
    ```bash
    1. The name of the kubernetes cluster
    2. The name of the resource group previously created for the challenge resources
    3. The number of nodes of the kubernetes cluster
    4. The vm size of the nodes of the kubernetes cluster
    ```

    After the script execution remember to take note of the CALL TO ACTION annotation:

    ```bash
    1. KubernetesCluster
    2. KubernetesClusterResourceGroup
    ```

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough" target="_blank">cheat link!</a>

Step 11:
- Create a new SendGrid resource, for this step you have two options: do it manually or executing the cloud shell bash script located in <b>challenge-01/configuration/sendgrid/config.sh</b>.

    <b>Important:</b> In this script you will need to provide:
    
    ```bash
    1. The name of the SendGrid account
    2. The name of the resource group previously created for the challenge resources
    3. The location of the resource group previously created for the challenge resources
    4. The SendGrid creator's email
    5. The SendGrid creator's first name
    6. The SendGrid creator's lastname
    ```

    <b>Important:</b> After the resource creation, navigate in to the Portal, go to the resource and click in Manage option to configure a new API Key.

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/sendgrid-dotnet-how-to-send-email" target="_blank">cheat link!</a>

Step 12:
- At this point you will need to get the cluster credentials and validate the current context you will be working.

    Get cluster context locally: 

    ```bash
    az aks get-credentials --name [KubernetesCluster] --resource-group [KubernetesClusterResourceGroup]
    ```

    ```bash
    [KubernetesCluster] = kubernetes cluster name
    [KubernetesClusterResourceGroup] = kubernetes cluster resource group
    ```

    Validate current context:

    ```bash
    kubectl config current-context
    ```

    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/reference/kubectl/cheatsheet/" target="_blank">cheat link!</a>

Step 13:
- Create a Kubernetes Service namespace with the name: challenge-01.

    ```bash
    kubectl create namespace challenge-01
    ```

    <b>Having issues? </b> review the <a href="https://www.assistanz.com/steps-to-create-custom-namespace-in-the-kubernetes/" target="_blank">cheat link!</a>

Step 14:
- Configure the docker-registry secret for Kubernetes Service.
    <br />

    ```bash
    kubectl create secret docker-registry [dockerRegistrySecretName] --docker-server [acrRegistryName].azurecr.io --docker-username [acrRegistryUsername] --docker-password [acrRegistryPassword] --docker-email [acrEmailAccount] --namespace challenge-01
    ```

    ```bash
    [dockerRegistrySecretName] = the name of the docker-registry secret, e.g. robeceacr01-auth
    [acrRegistryName] = the name of the container registry previously created
    [acrRegistryUsername] = the username of the container registry previously created
    [acrRegistryPassword] = the password of the container registry previously created
    [dockerEmailAccount] = the email used in the subscription of the container registry previously created
    ```

    <b>Note:</b> [dockerEmailAccount] the email parameter is optional, you can add an email adress or just remove the --docker-email parameter.

    <b>Important:</b> Take note of the [dockerRegistrySecretName] you may use it later.

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/aks/concepts-security" target="_blank">cheat link!</a>

Step 15:
- <b>Install HELM 3</b> by following the instructions here: <a href="https://helm.sh/docs/intro/install/" target="_blank">https://helm.sh/docs/intro/install/</a>.

    To validate if helm was installed successfully, run the command: <b>helm version</b>.

    ```bash
    version.BuildInfo{Version:"v3.0.2", GitCommit:"19e47ee3283ae98139d98460de796c1be1e3975f", GitTreeState:"clean", GoVersion:"go1.13.15"}
    ```

    Optional: If using Windows 10, use any linux bash shell or the cloud shell bash directly in the Azure Portal.

    <b>Having issues? </b> review the <a href="https://alwaysupalwayson.blogspot.com/2019/11/helm-300-is-out.html" target="_blank">cheat link!</a>

Step 16:
- Let's deploy the RabbitMQ chart directly in the cluster using HELM 3. 
    <br />

    1. Go to <b>challenge-01/source</b> and then build the RabbitMQ docker image.

        ```bash
        az acr build -f rabbitmq/Dockerfile -t [acrRegistryName].azurecr.io/rabbitmq:1.0.0 -r [acrRegistryName] rabbitmq
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        ```

    2. In the same path <b>challenge-01/source</b> package the helm chart.

        ```bash
        helm package --version 1.0.0 --app-version=1.0.0 charts/rabbitmq-chart
        ```

    3. In the same path <b>challenge-01/source</b> push the package to the container registry.

        ```bash
        az acr helm push -n [acrRegistryName] -u [acrRegistryUsername] -p [acrRegistryPassword] rabbitmq-chart-1.0.0.tgz --force
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [acrRegistryUsername] = the username of the container registry
        [acrRegistryPassword] = the password of the container registry
        ```

    4. In the same path <b>challenge-01/source</b> add the repo to helm 3.

        ```bash
        helm repo add [acrRegistryName] https://[acrRegistryName].azurecr.io/helm/v1/repo --username [acrRegistryUsername] --password [acrRegistryPassword]
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [acrRegistryUsername] = the username of the container registry
        [acrRegistryPassword] = the password of the container registry
        ```

    5. Go to <b>challenge-01/source/charts</b> and then install RabbitMQ chart in the cluster by using HELM 3.

        ```bash
        helm upgrade --install --version 1.0.0 -n rabbitmq rabbitmq [acrRegistryName]/rabbitmq-chart --namespace=challenge-01 --set replicaCount=1 --set image.repository=[acrRegistryName].azurecr.io/rabbitmq --set ingress.enabled=false --set nameOverride=rabbitmq --set fullnameOverride=rabbitmq --set imagePullSecrets[0].name=[imagePullSecret]
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [imagePullSecret] = the name of the docker registry secret
        ```

    6. To validate the chart deployment use the following commands.

        ```bash
        To get the deployed pods in challenge-01 namespace:

        kubectl get pods --namespace challenge-01
        ```

        ```bash
        To get the deployed services in challenge-01 namespace:
        
        kubectl get services --namespace challenge-01
        ```

        ```bash
        To see the charts deployed using helm in challenge-01 namespace:
        
        helm list --namespace challenge-01
        ```

        ```bash
        To remove a chart deployed using helm in challenge-01 namespace:
        
        helm uninstall [chartName] --namespace challenge-01
        ```

    <b>Having issues? </b> review the <a href="https://alwaysupalwayson.blogspot.com/2019/11/helm-300-is-out.html" target="_blank">cheat link!</a>

Step 17:
- Get and take note of the RabbitMQ Cluster-IP address.
    <br />

    ```bash
    kubectl get services --namespace challenge-01
    ```
    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/reference/kubectl/cheatsheet/" target="_blank">cheat link!</a>

Step 18:
- Go to <b>challenge-01/secrets/reporting-service-api</b> and configure the settings.
    <br />

    ```json
    {
        "ApplicationSettings": {
            "RabbitMQUsername": "RABBITMQ-USERNAME",
            "RabbitMQPassword": "RABBITMQ-PASSWORD",
            "RabbitMQHostname": "RABBITMQ-HOSTNAME-OR-IP-ADDRESS",
            "RabbitMQPort": "RABBITMQ-PORT",
            "DispatchQueueName": "DISPATCH-QUEUE-NAME",
            "KeyVaultCertificateName": "KEY-VAULT-CERTIFICATE-NAME",
            "KeyVaultClientId": "KEY-VAULT-CLIENT-ID",
            "KeyVaultClientSecret": "KEY-VAULT-CLIENT-SECRET",
            "KeyVaultIdentifier": "KEY-VAULT-IDENTIFIER",
            "KeyVaultEncryptionKey": "KEY-VAULT-ENCRIPTION-KEY"
        },
        "Logging": {
            "LogLevel": {
            "Default": "Debug",
            "System": "Information",
            "Microsoft": "Information"
            }
        }
    }
    ```

    Set the values:

    ```bash
    [RabbitMQUsername] = guest
    [RabbitMQPassword] = guest
    [RabbitMQHostname] = rabbitmq service cluster ip address (previously defined)
    [RabbitMQPort] = 5672
    [DispatchQueueName] = dispatch
    [KeyVaultCertificateName] = key vault certificate name (previously defined)
    [KeyVaultClientId] = AAD application app Id (previously defined)
    [KeyVaultClientSecret] = AAD application client secret (previously defined)
    [KeyVaultIdentifier] = key vault identifier (previously defined) (e.g. https://keyvaultname.vault.azure.net)
    [KeyVaultEncryptionKey] = key vault encryption key (previously defined)
    ```

- In the same folder path execute.

    ```bash
    kubectl create secret generic appsettings-secrets-reporting-service-api --from-file=appsettings.secrets.json --namespace challenge-01
    ```

    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/concepts/configuration/secret/" target="_blank">cheat link!</a>

Step 19:
- Let's deploy the Reporting Service API chart directly in the cluster using HELM 3. 
    <br />

    1. Go to <b>challenge-01/source</b> and then build the Reporting Service API docker image.

        ```bash
        az acr build -f reporting-service/ReportingService.Api/Dockerfile -t [acrRegistryName].azurecr.io/reporting-service-api:1.0.0 -r [acrRegistryName] reporting-service
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        ```

    2. In the same path <b>challenge-01/source</b> package the helm chart.

        ```bash
        helm package --version 1.0.0 --app-version=1.0.0 charts/reporting-service-api-chart
        ```

    3. In the same path <b>challenge-01/source</b> push the package to the container registry.

        ```bash
        az acr helm push -n [acrRegistryName] -u [acrRegistryUsername] -p [acrRegistryPassword] reporting-service-api-chart-1.0.0.tgz --force
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [acrRegistryUsername] = the username of the container registry
        [acrRegistryPassword] = the password of the container registry
        ```

    4. In the same path <b>challenge-01/source</b> add the repo to helm 3.

        ```bash
        helm repo add [acrRegistryName] https://[acrRegistryName].azurecr.io/helm/v1/repo --username [acrRegistryUsername] --password [acrRegistryPassword]
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [acrRegistryUsername] = the username of the container registry
        [acrRegistryPassword] = the password of the container registry
        ```

    5. Go to <b>challenge-01/source/charts</b> and then install Reporting Service API chart in the cluster by using HELM 3.

        ```bash
        helm upgrade --install --version 1.0.0 -n reporting-service-api reporting-service-api [acrRegistryName]/reporting-service-api-chart --namespace=challenge-01 --set replicaCount=1 --set image.repository=[acrRegistryName].azurecr.io/reporting-service-api --set ingress.enabled=false --set nameOverride=reporting-service-api --set fullnameOverride=reporting-service-api --set imagePullSecrets[0].name=[imagePullSecret] --set volumes[0].name=secrets --set volumes[0].secret.secretName=[volumeSecretName]
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [imagePullSecret] = the name of the docker registry secret
        [volumeSecretName] = the name of the secret for the appsettings.secrets.json
        ```

    6. To validate the chart deployment use the following commands.

        ```bash
        To get the deployed pods in challenge-01 namespace:

        kubectl get pods --namespace challenge-01
        ```

        ```bash
        To get the deployed services in challenge-01 namespace:
        
        kubectl get services --namespace challenge-01
        ```

        ```bash
        To see the charts deployed using helm in challenge-01 namespace:
        
        helm list --namespace challenge-01
        ```

        ```bash
        To remove a chart deployed using helm in challenge-01 namespace:
        
        helm uninstall [chartName] --namespace challenge-01
        ```

    <b>Having issues? </b> review the <a href="https://alwaysupalwayson.blogspot.com/2019/11/helm-300-is-out.html" target="_blank">cheat link!</a>

Step 20:
- Get and take note of the Reporting Service API Cluster-IP address.
    <br />

    ```bash
    kubectl get services --namespace challenge-01
    ```
    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/reference/kubectl/cheatsheet/" target="_blank">cheat link!</a>

Step 21:
- Go to <b>challenge-01/secrets/reporting-service-processor</b> and configure the settings.
    <br />

    ```json
    {
        "ApplicationSettings": {
            "ConnectionString": "CONNECTION-STRING",
            "DatabaseId": "DATABASE-ID",
            "ReportCollection": "REPORT-COLLECTION",
            "RabbitMQUsername": "RABBITMQ-USERNAME",
            "RabbitMQPassword": "RABBITMQ-PASSWORD",
            "RabbitMQHostname": "RABBITMQ-HOSTNAME-OR-IP-ADDRESS",
            "RabbitMQPort": "RABBITMQ-PORT",
            "DispatchQueueName": "DISPATCH-QUEUE-NAME",
            "KeyVaultCertificateName": "KEY-VAULT-CERTIFICATE-NAME",
            "KeyVaultClientId": "KEY-VAULT-CLIENT-ID",
            "KeyVaultClientSecret": "KEY-VAULT-CLIENT-SECRET",
            "KeyVaultIdentifier": "KEY-VAULT-IDENTIFIER",
            "KeyVaultEncryptionKey": "KEY-VAULT-ENCRIPTION-KEY",
            "SendGridAPIKey": "SENDGRID-API-KEY"
        }
    }
    ```

    Set the values:

    ```bash
    [ConnectionString] = cosmosdb connection string (previously defined)
    [DatabaseId] = cosmosdb database id (previously defined)
    [ReportCollection] = report
    [RabbitMQUsername] = guest
    [RabbitMQPassword] = guest
    [RabbitMQHostname] = rabbitmq service cluster ip address (previously defined)
    [RabbitMQPort] = 5672
    [DispatchQueueName] = dispatch
    [KeyVaultCertificateName] = key vault certificate name (previously defined)
    [KeyVaultClientId] = AAD application app Id (previously defined)
    [KeyVaultClientSecret] = AAD application client secret (previously defined)
    [KeyVaultIdentifier] = key vault identifier (previously defined) (e.g. https://keyvaultname.vault.azure.net)
    [KeyVaultEncryptionKey] = key vault encryption key (previously defined)
    [SendGridAPIKey] = sendgrid api key (previously defined)
    ```

- In the same folder path execute.

    ```bash
    kubectl create secret generic appsettings-secrets-reporting-service-processor --from-file=appsettings.secrets.json --namespace challenge-01
    ```

    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/concepts/configuration/secret/" target="_blank">cheat link!</a>

Step 22:
- Let's deploy the Reporting Service Processor chart directly in the cluster using HELM 3. 
    <br />

    1. Go to <b>challenge-01/source</b> and then build the Reporting Service Processor docker image.

        ```bash
        az acr build -f reporting-service/ReportingService.Processor/Dockerfile -t [acrRegistryName].azurecr.io/reporting-service-processor:1.0.0 -r [acrRegistryName] reporting-service
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        ```

    2. In the same path <b>challenge-01/source</b> package the helm chart.

        ```bash
        helm package --version 1.0.0 --app-version=1.0.0 charts/reporting-service-processor-chart
        ```

    3. In the same path <b>challenge-01/source</b> push the package to the container registry.

        ```bash
        az acr helm push -n [acrRegistryName] -u [acrRegistryUsername] -p [acrRegistryPassword] reporting-service-processor-chart-1.0.0.tgz --force
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [acrRegistryUsername] = the username of the container registry
        [acrRegistryPassword] = the password of the container registry
        ```

    4. In the same path <b>challenge-01/source</b> add the repo to helm 3.

        ```bash
        helm repo add [acrRegistryName] https://[acrRegistryName].azurecr.io/helm/v1/repo --username [acrRegistryUsername] --password [acrRegistryPassword]
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [acrRegistryUsername] = the username of the container registry
        [acrRegistryPassword] = the password of the container registry
        ```

    5. Go to <b>challenge-01/source/charts</b> and then install Reporting Service Processor chart in the cluster by using HELM 3.

        ```bash
        helm upgrade --install --version 1.0.0 -n reporting-service-processor reporting-service-processor [acrRegistryName]/reporting-service-processor-chart --namespace=challenge-01 --set replicaCount=1 --set image.repository=[acrRegistryName].azurecr.io/reporting-service-processor --set nameOverride=reporting-service-processor --set fullnameOverride=reporting-service-processor --set imagePullSecrets[0].name=[imagePullSecret] --set volumes[0].name=secrets --set volumes[0].secret.secretName=[volumeSecretName]
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [imagePullSecret] = the name of the docker registry secret
        [volumeSecretName] = the name of the secret for the appsettings.secrets.json
        ```

    6. To validate the chart deployment use the following commands.

        ```bash
        To get the deployed pods in challenge-01 namespace:

        kubectl get pods --namespace challenge-01
        ```

        ```bash
        To get the deployed services in challenge-01 namespace:
        
        kubectl get services --namespace challenge-01
        ```

        ```bash
        To see the charts deployed using helm in challenge-01 namespace:
        
        helm list --namespace challenge-01
        ```

        ```bash
        To remove a chart deployed using helm in challenge-01 namespace:
        
        helm uninstall [chartName] --namespace challenge-01
        ```

    <b>Note:</b> Since Reporting Service Processor is a .NET Core console app it doesn't require any exposed internal or public ip address. 

    <b>Having issues? </b> review the <a href="https://alwaysupalwayson.blogspot.com/2019/11/helm-300-is-out.html" target="_blank">cheat link!</a>

Step 23:
- Go to <b>challenge-01/secrets/reporting-service-website</b> and configure the settings.
    <br />

    ```json
    {
        "ApplicationSettings": {
            "APIHostname": "API-HOSTNAME-OR-IP-ADDRESS"
        },
        "Logging": {
            "LogLevel": {
            "Default": "Warning"
            }
        },
        "AllowedHosts": "*"
    }
    ```

    Set the values:

    ```bash
    [APIHostname] = api service cluster ip address (previously defined)
    ```

- In the same path folder execute.

    ```bash
    kubectl create secret generic appsettings-secrets-reporting-service-website --from-file=appsettings.secrets.json --namespace challenge-01
    ```

    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/concepts/configuration/secret/" target="_blank">cheat link!</a>

Step 24:
- Let's deploy the Reporting Service Website chart directly in the cluster using HELM 3. 
    <br />

    1. Go to <b>challenge-01/source</b> and then build the Reporting Service Website docker image.

        ```bash
        az acr build -f reporting-service/ReportingService.Website/Dockerfile -t [acrRegistryName].azurecr.io/reporting-service-website:1.0.0 -r [acrRegistryName] reporting-service
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        ```

    2. In the same path <b>challenge-01/source</b> package the helm chart.

        ```bash
        helm package --version 1.0.0 --app-version=1.0.0 charts/reporting-service-website-chart
        ```

    3. In the same path <b>challenge-01/source</b> push the package to the container registry.

        ```bash
        az acr helm push -n [acrRegistryName] -u [acrRegistryUsername] -p [acrRegistryPassword] reporting-service-website-chart-1.0.0.tgz --force
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [acrRegistryUsername] = the username of the container registry
        [acrRegistryPassword] = the password of the container registry
        ```

    4. In the same path <b>challenge-01/source</b> add the repo to helm 3.

        ```bash
        helm repo add [acrRegistryName] https://[acrRegistryName].azurecr.io/helm/v1/repo --username [acrRegistryUsername] --password [acrRegistryPassword]
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [acrRegistryUsername] = the username of the container registry
        [acrRegistryPassword] = the password of the container registry
        ```

    5. Go to <b>challenge-01/source/charts</b> and then install Reporting Service Website chart in the cluster by using HELM 3.

        ```bash
        helm upgrade --install --version 1.0.0 -n reporting-service-website reporting-service-website [acrRegistryName]/reporting-service-website-chart --namespace=challenge-01 --set replicaCount=1 --set image.repository=[acrRegistryName].azurecr.io/reporting-service-website --set ingress.enabled=false --set nameOverride=reporting-service-website --set fullnameOverride=reporting-service-website --set imagePullSecrets[0].name=[imagePullSecret] --set volumes[0].name=secrets --set volumes[0].secret.secretName=[volumeSecretName]
        ```

        ```bash
        [acrRegistryName] = the name of the container registry previously created
        [imagePullSecret] = the name of the docker registry secret
        [volumeSecretName] = the name of the secret for the appsettings.secrets.json
        ```

    6. To validate the chart deployment use the following commands.

        ```bash
        To get the deployed pods in challenge-01 namespace:

        kubectl get pods --namespace challenge-01
        ```

        ```bash
        To get the deployed services in challenge-01 namespace:
        
        kubectl get services --namespace challenge-01
        ```

        ```bash
        To see the charts deployed using helm in challenge-01 namespace:
        
        helm list --namespace challenge-01
        ```

        ```bash
        To remove a chart deployed using helm in challenge-01 namespace:
        
        helm uninstall [chartName] --namespace challenge-01
        ```

    <b>Having issues? </b> review the <a href="https://alwaysupalwayson.blogspot.com/2019/11/helm-300-is-out.html" target="_blank">cheat link!</a>

Step 25:
- Get and take note of the Reporting Service Website External-IP address.
    <br />

    ```bash
    kubectl get services --namespace challenge-01
    ```
    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/reference/kubectl/cheatsheet/" target="_blank">cheat link!</a>

Step 26:
- <b>This step is optional</b>, in case you want to debug and run the source applications locally ensure you have Visual Studio or Visual Code installed and the right the appsettings for each application.

    <b>Important:</b> You will need to have Docker installed to start RabbitMQ container since there are no source code in this challenge for this service.

    <b>Having issues? </b> review the <a href="https://www.freecodecamp.org/news/docker-easy-as-build-run-done-e174cc452599/" target="_blank">cheat link!</a>

Step 27:
- In Azure DevOps and set up a new Azure Resource Manager Service Connection, pointing to the subscription where is the Kubernetes Cluster resource group.

    <b>Important:</b> Ensure you have checked the option "Allow all pipelines to use this connection" when create the service connection.

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml" target="_blank">cheat link!</a>

Step 28:
- In Azure DevOps, create a new environment with the name: Testing Environment.

    <b>Note:</b> If you don't see the Environment feature in Azure DevOps Pipelines, you may need to activate the new features: https://docs.microsoft.com/en-us/azure/devops/project/navigation/preview-features?view=azure-devops.
    
    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops" target="_blank">cheat link!</a>

Step 29:
- In Azure DevOps, select the environment with the name: Testing Environment and add approval permission.

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops" target="_blank">cheat link!</a>

Step 30:
- In Azure DevOps, create a new pipeline for each application, following the next steps.
    + <b>Connect</b> to the Azure Repo Git.
    + <b>Select the repository</b> where are located the build-deploy yaml scripts.
    + <b>Configure the pipeline</b> using the "Existing Azure Pipelines yaml file" option.
    + <b>Select the existing yaml file</b>, e.g. rabbitmq-build-deploy.yml.
    + <b>Run</b> the pipeline.

    <br />

    + <b>Note:</b> The first time you run the yaml pipeline it will fail because there are some missing variables that need to be set in the pipeline.

    + Azure DevOps needs to have four pipelines added:
        - RabbitMQ Service pipeline (build-deploy).
        - Reporting API Service pipeline (build-deploy).
        - Reporting Processor Service pipeline (build-deploy).
        - Reporting Website pipeline (build-deploy).

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/devops/pipelines/ecosystems/dotnet-core?view=azure-devops" target="_blank">cheat link!</a>

Step 31:
- In Azure DevOps, edit each pipeline and add the environment variables need it. Each script has a commented variables that need to be added in to the pipeline to run succesfully, you don't need to edit the pipeline code, this change should be directly in Azure DevOps.

    Example:
    ```bash
    # define 10 more variables in the build pipeline in UI: 
    # 1. acrRegistryName
    # 2. acrRegistryUsername
    # 3. acrRegistryPassword
    # 4. imagePullSecret
    # 5. replicaCount
    # 6. azureSubscriptionEndpoint
    # 7. kubernetesClusterResourceGroup
    # 8. kubernetesCluster
    # 9. volumeSecretName
    ```

    In this example  you will set the values:
    ```bash
    [acrRegistryName] = the name of the container registry
    [acrRegistryUsername] = the username of the container registry
    [acrRegistryPassword] = the password of the container registry
    [imagePullSecret] = the name of the docker registry secret
    [replicaCount] = the number of replicas of the pods
    [azureSubscriptionEndpoint] = the name of the service connection
    [kubernetesClusterResourceGroup] = the name of the kubernetes service cluster resource group
    [kubernetesCluster] = the name of the kubernetes service cluster
    [volumeSecretName] = the name of the secret for the appsettings.secrets.json
    ```

    <b>Note:</b> Repeat the last two steps for each application, review each pipeline to validate if it's correctly configured, with these pipelines all applications will be configured with CI/CD in Kubernetes cluster.

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/devops/pipelines/process/variables?view=azure-devops&tabs=yaml%2Cbatch" target="_blank">cheat link!</a>

Step 32:
- Run each pipeline and approve to deploy, ensure the releases have been deployed successfully, pods and services must be up and running in the Kubernetes Service, validate it by opening the Kubernetes dashboard.

- Get the credentials to the local machine.
    ```bash
    az aks get-credentials --name [kubernetesCluster] --resource-group [kubernetesClusterResourceGroup] 
    ```

- Open the Kubernetes dashboard.
    ```bash
    az aks browse --name [kubernetesCluster] --resource-group [kubernetesClusterResourceGroup] 
    ```

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/aks/kubernetes-dashboard" target="_blank">cheat link!</a>

Step 33:
- Congratulations, you are now able to navigate through the reporting service website app by using the external-ip previously assigned. Once you filled the website form a new message will be send to the queue and be processed by the processor console, in a moment you will receive an email with an attached PDF with the information provided in the website form.

## HELM Commands

After the automated deployments you may want to list or delete helm charts from the Kubernetes Service, there are some commands here, in case need more details, review the cheat link.

- If need to to list HELM charts installed in Kubernetes.
    ```bash
    helm ls --namespace [namespace]
    ```

- If need to delete a HELM chart in Kubernetes.
    ```bash
    helm uninstall --namespace [namespace]
    ```

    <b>Having issues? </b> review the <a href="https://v3.helm.sh/docs/intro/using_helm/" target="_blank">cheat link!</a>

## Closure

You have now the knowledge to create a new Cloud Native DevOps CI/CD pipelines end-to-end with Microservices on Azure Kubernetes Services, I strongly suggest dig into the code to understand how microservices, configuration scripts and charts have been made as part of the practices provided in this content.