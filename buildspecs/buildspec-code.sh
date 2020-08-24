set -ex

terraform plan --out plan --input=false -var="repository_name=$REPOSITORY_NAME" -var="aws_account=$ACCOUNT_NAME_RAW"