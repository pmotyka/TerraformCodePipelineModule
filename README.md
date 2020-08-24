# TerraformCodePipelineModule

An importable, Terraform defined, CodePipeline module used to deliver Terraform payloads.

This is primarily to be executed by Pipeline Lifecycle Manager, which will stand up and tear down pipelines, for which you need to have the module imported into your repository using the best practices as seen in the Example repos.

Pipelines created by this module will execute when new commits are pushed to the branch it follows and also every night.

To use it, you might incorporate it as follows:

```terraform
terraform {
  backend "s3" {}
}

locals {
  tags = {
    Order       = "70038033"
    Owner       = "MRAD"
    AppID       = "1795"
    Org         = "MRAD"
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

The pipeline module expects that your buildspecs are two directories down from the pipeline. An example of this folder structure might involve buildspecs at `buildspecs/` relative to repo root and the pipeline at `terraform/pipeline/main.tf`.

In order to execute the pipeline "locally", you need to:

- be authenticated and role-assumed into the correct AWS environment,
- create a backendConfig file as shown in the Lambdas-Terraform-Example repository,
- pass or set the needed variables, and
- set the workspace as the github branch

For handling these with a script you can use the `deploy_pipelines.sh` script found in the Example repositories.

# List of Variables

```
region
repository_name
tags
node_env (default: dev)
use_custom_image (default: true)
aws_account
```

# Custom Build image

There is a [custom codebuild](https://github.com/$GITHUB_ORG/mrad-codebuild-image/tree/development) docker image that is utilized by default. To opt out, set `use_custom_image` to false.
