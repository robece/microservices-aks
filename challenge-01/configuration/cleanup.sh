#!/bin/bash
clear

# NOTE: before run this script ensure you are logged in Azure by using az login command.

read -p "Introduce a lowercase unique alias of the deployment you want to cleanup: " DeploymentAlias
ResourceGroupName=$DeploymentAlias"-workshop"
AKSResourceNodeGroupName=$DeploymentAlias"-workshop-node-group"

# delete delete general resource group
az group delete -n $ResourceGroupName --no-wait

# delete delete aks node group resource group
az group delete -n $AKSResourceNodeGroupName --no-wait