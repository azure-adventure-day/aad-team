#!/usr/bin/env bash
set -o pipefail

# ./deploy-team.sh team1 northeurope 7d5e75b2-356e-4bf6-b12f-24e2e79a8269


export team_name="${1,,}"
export location="${2,,}"
export subscriptionid="$3"

if [ "$team_name" == "" ]; then
echo "No team_name provided - aborting"
exit 0;
fi

if [[ $team_name =~ ^[a-z0-9]{3,6}$ ]]; then
    echo "Deployment $team_name name is valid"
else
    echo "Deployment $team_name name is invalid - only numbers and lower case min 3 and max 6 characters allowed - aborting"
    exit 0;
fi

if [ "$location" == "" ]; then
location="northeurope"
echo "No location provided - defaulting to $location"
fi

if [ "$subscriptionid" == "" ]; then
subscriptionid=$(az account show --query id -o tsv)
echo "No subscriptionid provided defaulting to $subscriptionid"
else
az account set --subscription $subscriptionid
fi

tenantid=$(az account show --query tenantId -o tsv)

echo "This script will create an environment for team $team_name in $location"

TERRAFORM_STORAGE_NAME="tf${team_name}${location}"
TERRAFORM_STATE_RESOURCE_GROUP_NAME="${team_name}${location}_tfstate_rg"

echo "creating terraform state storage..."
TFGROUPEXISTS=$(az group show --name $TERRAFORM_STATE_RESOURCE_GROUP_NAME --query name -o tsv --only-show-errors)
if [ "$TFGROUPEXISTS" == $TERRAFORM_STATE_RESOURCE_GROUP_NAME ]; then 
echo "terraform storage resource group $TERRAFORM_STATE_RESOURCE_GROUP_NAME exists"
else
echo "creating terraform storage resource group $TERRAFORM_STATE_RESOURCE_GROUP_NAME..."
az group create -n $TERRAFORM_STATE_RESOURCE_GROUP_NAME -l $location --output none
fi

if [ -z "$AZURE_CREDENTIALS" ]; then 
    echo "Did not detect GitHub Actions Environment"
else
    echo "Detected GitHub Actions Environment"
    export ARM_CLIENT_ID="$( echo $AZURE_CREDENTIALS | jq -r .clientId )"
    export ARM_CLIENT_SECRET="$( echo $AZURE_CREDENTIALS | jq -r .clientSecret )"
    export ARM_SUBSCRIPTION_ID="$( echo $AZURE_CREDENTIALS | jq -r .subscriptionId)"
    export ARM_TENANT_ID="$( echo $AZURE_CREDENTIALS | jq -r .tenantId )"
fi

TFSTORAGEEXISTS=$(az storage account show -g $TERRAFORM_STATE_RESOURCE_GROUP_NAME -n $TERRAFORM_STORAGE_NAME --query name -o tsv)
if [ "$TFSTORAGEEXISTS" == $TERRAFORM_STORAGE_NAME ]; then 
echo "terraform storage account $TERRAFORM_STORAGE_NAME exists"
TERRAFORM_STORAGE_KEY=$(az storage account keys list --account-name $TERRAFORM_STORAGE_NAME --resource-group $TERRAFORM_STATE_RESOURCE_GROUP_NAME --query "[0].value" -o tsv)
else
echo "creating terraform storage account $TERRAFORM_STORAGE_NAME..."
az storage account create --resource-group $TERRAFORM_STATE_RESOURCE_GROUP_NAME --name $TERRAFORM_STORAGE_NAME --location $location --sku Standard_LRS --output none
TERRAFORM_STORAGE_KEY=$(az storage account keys list --account-name $TERRAFORM_STORAGE_NAME --resource-group $TERRAFORM_STATE_RESOURCE_GROUP_NAME --query "[0].value" -o tsv)
az storage container create -n tfstate --account-name $TERRAFORM_STORAGE_NAME --account-key $TERRAFORM_STORAGE_KEY --output none
fi

echo "initializing terraform state storage..."

cd team

terraform init -backend-config="storage_account_name=$TERRAFORM_STORAGE_NAME" -backend-config="container_name=tfstate" -backend-config="access_key=$TERRAFORM_STORAGE_KEY" -backend-config="key=codelab.microsoft.tfstate"

echo "planning terraform..."
terraform plan -out out.plan -var="deployment_name=$team_name" -var="location=$location" -var="tenant_id=$tenantid" -var="subscription_id=$subscriptionid"

echo "running terraform apply..."
terraform apply out.plan
