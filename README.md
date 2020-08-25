# TerraformCodePipelineModule

This module defines a *pipeline* which can deliver a *payload*. Specifically, an importable, Terraform defined, CodePipeline module used to deliver Terraform *payloads* to and AWS account, which are also typically considered as *workloads* (this is out of the scope of landing zone solutions).

*Pipelines* created by this module will execute when new commits are pushed to the corresponding repo & branch it is connected to.

An example consumer app using this pipeline module can be found @ https://code.amazon.com/packages/TerraformExamplePayload/trees/mainline.

This project is intended to integrate with github

To use it, you might incorporate it as follows:

```terraform
terraform {
  backend "s3" {}
}

locals {
  tags = {
    Owner       = "chrilebl"
    ProjectName = "${var.repository_name}-Pipeline"
  }
}

module "pipeline" {
  source          = "github.com/$GITHUB_ORG/TerraformCodePipelineModule"
  tags            = local.tags
  region          = "us-west-2"
  repository_name = var.repository_name
}
```

The pipeline module expects that your *payload* contains the following directory structure and key files, for ease of automation.

```
buildspecs/
  buildspec-plan.sh
  buildspec-plan.yml
  buildspec-plan.sh
  buildspec-apply.yml
*.tf
```

This repo also includes terraform to bootstrap the backend storage for a terraform envionment, and can be ran from the `bootstrap` directory by executing `terraform apply` in an authenticated shell. This will provision Terraform state storage as described @ https://www.terraform.io/docs/backends/types/s3.html.

# How to use 

1. Install Terraform
2. Authenticate a shell against an AWS account & code.amazon
3. Mirror these repos in your/customer's github account
  - (This repo)
  - https://code.amazon.com/packages/TerraformExamplePayload/trees/mainline
  - https://code.amazon.com/packages/TerraformLambdaModule/trees/mainline
4. Bootstrap a terraform s3 backend via `cd bootstrap && terraform apply`
5. Create 3 SSM string parameters
  - GITHUB_TOKEN - a github token allowing repo access
  - WEBHOOK_TOKEN - an arbitrary secret used to create a github webhook

# List of Variables Supported by this Terraform Module

```
region (the aws region in which to deploy)
repository_name (the name of the github repository to integrate your pipeline with)
tags (the tags to use on your resources.)
```
