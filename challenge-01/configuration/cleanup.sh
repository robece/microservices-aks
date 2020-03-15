#!/bin/bash
clear

# NOTE: before run this script ensure you are logged in Azure by using az login command.

read -p "Introduce a lowercase unique alias of the deployment you want to cleanup: " DeploymentAlias
ResourceGroupName=$DeploymentAlias"-microservices-aks-c01"

# get location
LOCATION=$(az group show -n $ResourceGroupName --query id -o tsv)
AKSResourceNodeGroupName="MC_"$ResourceGroupName"_"$DeploymentAlias"aks01_"$LOCATION

# delete delete general resource group
az group delete -n $ResourceGroupName --no-wait

echo $AKSResourceNodeGroupName
# delete delete aks node group resource group
az group delete -n $AKSResourceNodeGroupName --no-wait

# get service principal
SP_APP_ID=$(az ad sp show --id http://$ResourceGroupName"-sp" --query appId -o tsv)

# delete service principal
az ad sp delete --id $SP_APP_ID