#!/bin/bash
set -e

export REPO=${PWD##*/}
export BRANCH="$(git branch | grep \* | cut -d ' ' -f2)"
export ACCOUNT_NAME=$(./account_name_from_branch.sh)
export TERRAFORM_WORKSPACE=$BRANCH
export NAMESPACE="cleblanc"

echo "Repo is $REPO"
echo "Branch is $BRANCH"
echo "ACCOUNT_NAME is $ACCOUNT_NAME"
echo "TERRAFORM_WORKSPACE is $TERRAFORM_WORKSPACE"


cd terraform/pipeline/ && \
     rm -f .terraform/terraform.tfstate && \
     rm -f .terraform/environment && \
     terraform get -update && \
    #  terraform init -backend-config=backendConfig.tfvars && \
     terraform init \
     -backend-config="bucket=$NAMESPACE-terraform-backend-$ACCOUNT_NAME" \
     -backend-config="region=us-west-2" \
     -backend-config="dynamodb_table=terraform-state-lock" \
     -backend-config="key=$REPO/pipeline.tfstate"&& \
     (terraform workspace new $TERRAFORM_WORKSPACE || true) && \
     terraform workspace select $TERRAFORM_WORKSPACE && \
     terraform apply -var repository_name=$REPO -var aws_account=$ACCOUNT_NAME_RAW
cd -