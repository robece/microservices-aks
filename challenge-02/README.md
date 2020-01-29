# Challenge 2

Ingress Controller on Azure Kubernetes Service challenge is designed to foster learning via implementing Cloud Native Routing practices with a series of steps, the sample solution is based on NGINX and Apache HTTP web servers presented as containerized services on Azure Kubernetes Services using the ingress controller with cert-manager for routing and secure exposure.

## Services

The solution is splitted in the following services:

- NGINX (a web server which can also be used as a reverse proxy, load balancer, mail proxy and http cache)
- Apache HTTP Server (a web server application notable for playing a key role in the initial growth of the world wide web)

## Technology Stack 

Azure Cloud Services:
- Kubernetes Service

## Prerequisites

1. An active Azure subscription, there are several ways you can procure one:
    * <a href="https://azure.microsoft.com/en-us/free/" target="_blank">Azure Free Account</a>
    * <a href="https://visualstudio.microsoft.com/dev-essentials/" target="_blank">Visual Studio Dev Essentials</a>
    * <a href="https://azure.microsoft.com/en-us/pricing/member-offers/credit-for-visual-studio-subscribers/" target="_blank">Monthly Azure credit for Visual Studio subscribers</a>
2. <a href="https://code.visualstudio.com/" target="_blank">VS Code</a> o <a href="https://visualstudio.microsoft.com/vs/community/" target="_blank">Visual Studio 2019 Community</a>
3. Docker Desktop (<a href="https://www.docker.com/get-started" target="_blank">https://www.docker.com/get-started</a>). For for older Mac and Windows systems that do not meet the requirements of <a href="https://docs.docker.com/docker-for-mac/" target="_blank">Docker Desktop for Mac</a> and <a href="https://docs.docker.com/docker-for-windows/" target="_blank">Docker Desktop for Windows</a> you could use <a href="https://docs.docker.com/toolbox/toolbox_install_windows/" target="_blank">Docker Toolbox</a>.

## Architecture

<div style="text-align:center">
    <img src="/challenge-02/resources/images/ingress-architecture.png" width="600" />
</div>

## First Time?

Is this your first time using Docker?, review the following links:

1. <a href="https://docs.docker.com/get-started/" target="_blank">Docker, get started documentation</a>

Is this your first time using Kubernetes Service?, review the following links:

1. <a href="https://docs.microsoft.com/en-us/azure/aks/intro-kubernetes" target="_blank">Azure Kubernetes Service (AKS)</a>

2. <a href="https://docs.microsoft.com/en-us/azure/aks/concepts-clusters-workloads" target="_blank">Kubernetes core concepts for Azure Kubernetes Service (AKS)</a>

3. <a href="https://azure.microsoft.com/en-us/resources/kubernetes-learning-path/" target="_blank">Kubernetes learning path</a>

Is this your first time using Ingress Controller?, review the following links:

1. <a href="https://kubernetes.io/docs/concepts/services-networking/ingress/" target="_blank">Ingress, get started documentation</a>

2. <a href="https://docs.microsoft.com/en-us/azure/aks/concepts-network#ingress-controllers" target="_blank">Ingress Controller in Azure Kubernetes Service</a>

Is this your first time using Cert-Manager?, review the following links:

1. <a href="https://cert-manager.io/docs/" target="_blank">Cert-Manager, get started documentation</a>

## Hack Goals

1. The NGINX web server must be running and needs to be exposed in a specific cluster ip address.

2. The Apache HTTP Server must be running and needs to be exposed in a specific cluster ip address.

3. Ingress Controller must be installed in the cluster and replicated at least in two pods.

4. Production certificate must be generated correctly to expose a secure dns for ingress controller.

5. The Kubernetes Service must be up and running ready for monitoring through the dashboard.

6. NGINX and Apache HTTP Server must be able to accessible through the secure ingress controller dns.

## Let's Hack

Step 1:
- Sign in to <a href="https://portal.azure.com" target="_blank">Azure Portal </a> and open the cloud shell bash or use the <a href="https://shell.azure.com/bash" target="_blank">Azure Cloud Shell</a>.

    <b>Having issues? </b> review the <a href="https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/cloud-shell/overview.md" target="_blank">cheat link!</a>


Step 2:
- Using the cloud shell bash clone the GitHub repo.
    ```bash
    git clone https://github.com/robece/microservices-aks.git
    ```

    <b>Having issues? </b> review the <a href="https://help.github.com/en/articles/cloning-a-repository" target="_blank">cheat link!</a>

Step 3:
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

Step 4:
- Create a new Kubernetes Service resource, for this step you have two options: do it manually or executing the cloud shell bash script located in <b>challenge-02/configuration/kubernetes-service/config.sh</b>.

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

Step 5:
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

Step 6:
- Create a Kubernetes Service namespaces.

    Challenge-02 namespace:

    ```bash
    kubectl create namespace challenge-02
    ```

    Cert-Manager namespace:

    ```bash
    kubectl create namespace cert-manager
    ```

    <b>Having issues? </b> review the <a href="https://www.assistanz.com/steps-to-create-custom-namespace-in-the-kubernetes/" target="_blank">cheat link!</a>

Step 7:
- <b>Install HELM 3</b> by following the instructions here: <a href="https://helm.sh/docs/intro/install/" target="_blank">https://helm.sh/docs/intro/install/</a>.

    To validate if helm was installed successfully, run the command: <b>helm version</b>.

    ```bash
    version.BuildInfo{Version:"v3.0.2", GitCommit:"e29ce2a54e96cd02ccfce88bee4f58bb6e2a28b6", GitTreeState:"clean", GoVersion:"go1.13.15"}
    ```

    Optional: If using Windows 10, use any linux bash shell or the cloud shell bash directly in the Azure Portal.

    <b>Having issues? </b> review the <a href="https://helm.sh/docs/" target="_blank">cheat link!</a>

Step 8:
- Go to <b>challenge-02/source</b> and then deploy the nginx script directly in the cluster.

    ```bash
    kubectl apply -f deployment-nginx.yml
    ```

    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/reference/kubectl/cheatsheet/" target="_blank">cheat link!</a>

Step 9:
- In the same path <b>challenge-02/source</b> expose internally the deployment.

    ```bash
    kubectl expose deployment nginx --namespace challenge-02
    ```

    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/reference/kubectl/cheatsheet/" target="_blank">cheat link!</a>

Step 10:
- Go to <b>challenge-02/source</b> and then deploy the nginx script directly in the cluster.

    ```bash
    kubectl apply -f deployment-httpd.yml
    ```

    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/reference/kubectl/cheatsheet/" target="_blank">cheat link!</a>

Step 11:
- In the same path <b>challenge-02/source</b> expose internally the deployment.

    ```bash
    kubectl expose deployment httpd --namespace challenge-02
    ```

    <b>Having issues? </b> review the <a href="https://kubernetes.io/docs/reference/kubectl/cheatsheet/" target="_blank">cheat link!</a>

Step 12:
- Let's deploy the ingress controller chart directly in the cluster using HELM 3. 

    1. Add the Kubernetes charts repository.

        ```bash
        helm repo add stable https://kubernetes-charts.storage.googleapis.com/
        ```

    2. Update helm repositories. 
        
        ```bash
        helm repo update
        ```

    3. Install the ingress controller in the cluster. 

        ```bash
        helm install --generate-name stable/nginx-ingress --set controller.replicaCount=2 --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux --version=1.26.2 --namespace challenge-02
        ```
    
    4. Get ingress controller service external ip.

        ```bash
        kubectl get service -l app=nginx-ingress --namespace challenge-02
        ```

    5. To validate the chart deployment use the following commands.

        ```bash
        To get the deployed pods in challenge-02 namespace:

        kubectl get pods --namespace challenge-02
        ```

        ```bash
        To get the deployed services in challenge-02 namespace:
        
        kubectl get services --namespace challenge-02
        ```

        ```bash
        To see the charts deployed using helm in challenge-02 namespace:
        
        helm list --namespace challenge-02
        ```

        ```bash
        To remove a chart deployed using helm in challenge-02 namespace:
        
        helm uninstall [chartName] --namespace challenge-02
        ```

    <b>Having issues? </b> review the <a href="https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/" target="_blank">cheat link!</a>

Step 13:
- Let's deploy the cert-manager chart directly in the cluster using HELM 3.

    1. Install the CustomResourceDefinition resources separately.

    ```bash
    kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.12/deploy/manifests/00-crds.yaml
    ```

    2. Label the cert-manager namespace to disable resource validation.

    ```bash
    kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true
    ```

    3. Add the Jetstack charts repository.

    ```bash
    helm repo add jetstack https://charts.jetstack.io
    ```

    4. Update helm repositories.

    ```bash
    helm repo update
    ```

    5. Install the cert-manager in the cluster. 

    ```bash
    helm install --generate-name jetstack/cert-manager --set nodeSelector."beta\.kubernetes\.io/os"=linux --set webhook.nodeSelector."beta\.kubernetes\.io/os"=linux --set cainjector.nodeSelector."beta\.kubernetes\.io/os"=linux --set ingressShim.defaultIssuerName=letsencrypt-prod --set ingressShim.defaultIssuerKind=ClusterIssuer --version v0.12.0 --namespace cert-manager
    ```

    6. To validate the chart deployment use the following commands.

    ```bash
    Monitoring certificates in specific namespace:

    kubectl describe certificate certificate --namespace cert-manager
    ```
    
    ```bash
    Monitoring cluster-issuer in specific namespace:

    kubectl describe clusterissuer letsencrypt-prod --namespace cert-manager
    ```

    ```bash
    To get the deployed pods in cert-manager namespace:

    kubectl get pods --namespace cert-manager
    ```

    ```bash
    To get the deployed services in cert-manager namespace:

    kubectl get services --namespace cert-manager
    ```

    ```bash
    To see the charts deployed using helm in cert-manager namespace:

    helm list --namespace cert-manager
    ```

    ```bash
    To remove a chart deployed using helm in cert-manager namespace:

    helm uninstall [chartName] --namespace cert-manager
    ```

    <b>Having issues? </b> review the <a href="https://cert-manager.io/docs/" target="_blank">cheat link!</a>

Step 14:
- Go to <b>challenge-02/configuration/scripts</b> modify and run the following scripts.

    1. Get the current external-ip address from nginx ingress controller service and replace the tag: [NGINX_INGRESS_PUBLIC_IP] in the dns-config.sh script.
    2. Create a unique DNS (e.g. robecedns01) and replace the tag: [NGINX_INGRESS_DNS] with the new value in the dns-config.sh script.
    3. Run the bash script:
        ```bash
        sh dns-config.sh
        ```

    4. Edit the cluster-issuer.yml file and replace the tag: [CUSTOM_EMAIL_ADDRESS] with a valid email.
    5. Run the command:
        ```bash
        kubectl apply -f cluster-issuer.yml
        ```

    6. Edit the certificate.yml file and replace the tag: [NGINX_INGRESS_DNS] with the valid DNS previously defined in the bash script.
    7. Edit the certificate.yml file and replace the tag: [CLUSTER_LOCATION] with the valid cluster location (e.g. westus | eastus).
    8. Run the command:
        ```bash
        kubectl apply -f certificate.yml
        ```

    9. To validate your certificate has been issued correctly by Let's Encrypt, run the command:

       ```bash
        kubectl describe certificate certificate --namespace cert-manager
        ```

        You will get some similar result:

        ```bash
        Name:         certificate
        Namespace:    cert-manager
        Labels:       <none>
        Annotations:  kubectl.kubernetes.io/last-applied-configuration:
                        {"apiVersion":"cert-manager.io/v1alpha2","kind":"Certificate","metadata":{"annotations":{},"name":"certificate","namespace":"cert-manager"...
        API Version:  cert-manager.io/v1alpha2
        Kind:         Certificate
        Metadata:
        Creation Timestamp:  2019-12-07T01:13:51Z
        Generation:          1
        Resource Version:    64154
        Self Link:           /apis/cert-manager.io/v1alpha2/namespaces/cert-manager/certificates/certificate
        UID:                 d49f9eaf-188e-11ea-b185-8ab8eabd5da6
        Spec:
        Dns Names:
            robece-challenge02.westus.cloudapp.azure.com
        Issuer Ref:
            Kind:       ClusterIssuer
            Name:       letsencrypt-prod
        Secret Name:  certificate
        Status:
        Conditions:
            Last Transition Time:  2019-12-07T01:14:17Z
            Message:               Certificate is up to date and has not expired
            Reason:                Ready
            Status:                True
            Type:                  Ready
        Not After:               2020-03-06T00:14:16Z
        Events:
        Type    Reason        Age   From          Message
        ----    ------        ----  ----          -------
        Normal  GeneratedKey  27s   cert-manager  Generated a new private key
        Normal  Requested     27s   cert-manager  Created new CertificateRequest resource "certificate-574162192"
        Normal  Issued        2s    cert-manager  Certificate issued successfully
        ```

    10. Edit the ingress-route.yml file and replace the tag: [NGINX_INGRESS_DNS] with the valid DNS previously defined in the bash script.
    11. Edit the ingress-route.yml file and replace the tag: [CLUSTER_LOCATION] with the valid cluster location (e.g. westus | eastus).
    12. Run the command:
        ```bash
        kubectl apply -f ingress-route.yml
        ```

    <b>Having issues? </b> review the <a href="https://docs.microsoft.com/en-us/azure/aks/ingress-static-ip/" target="_blank">cheat link!</a>

Step 15:
- Congratulations, you are now able to navigate through your exposed secured ingress controller to access to the internal load balancers in the cluster for NGINX and Apache HTTP Server.

## Closure

You have now the knowledge to create and configure a secured ingress controller to protect your internal applications.