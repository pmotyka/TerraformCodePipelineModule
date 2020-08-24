#/bin/bash
set -e

export REPO=${PWD##*/}
export BRANCH="$(git branch | grep \* | cut -d ' ' -f2)"
export ACCOUNT_NAME=$(./account_name_from_branch.sh | awk '{print tolower($0)}')
export ACCOUNT_NAME_RAW=$(./account_name_from_branch.sh)
export TERRAFORM_WORKSPACE=$BRANCH
export NAMESPACE="cleblanc"

echo "Repo is $REPO"
echo "Branch is $BRANCH"
echo "ACCOUNT_NAME is $ACCOUNT_NAME"
echo "ACCOUNT_NAME_RAW is $ACCOUNT_NAME_RAW"
echo "TERRAFORM_WORKSPACE is $TERRAFORM_WORKSPACE"

if [[ "$GIT_BRANCH" == "development" || "$GIT_BRANCH" == "master" || "$GIT_BRANCH" == "production" ]]; then
    echo "$GIT_BRANCH is protected, are you sure you want to delete? y/n"
    read DELETE_PROTECTED
    if [ "$DELETE_PROTECTED" != "y" ]; then
        exit 1
    fi
fi


cd terraform/pipeline/ && \
    rm -f .terraform/terraform.tfstate && \
    rm -f .terraform/environment && \
     terraform init \
     -backend-config="bucket=$NAMESPACE-terraform-backend-$ACCOUNT_NAME" \
     -backend-config="region=us-west-2" \
     -backend-config="dynamodb_table=terraform-state-lock" \
     -backend-config="key=$REPO/pipeline.tfstate"&& \
     (terraform workspace new $TERRAFORM_WORKSPACE || true) && \
    terraform workspace select $GIT_BRANCH && \
    terraform destroy -var repository_name=$REPO -var aws_account=$ACCOUNT_NAME_RAW
    terraform workspace select default
    terraform workspace delete $GIT_BRANCH


cd -

