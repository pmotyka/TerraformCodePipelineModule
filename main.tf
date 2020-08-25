terraform {
  backend "s3" {}
}

provider "aws" {
  region  = var.region
  version = "= 2.44.0"
}

provider "github" {
  token        = data.aws_ssm_parameter.github_token.value
  organization = var.github_org
}


/*
  --- Existing Resource(s) ---
*/

data "aws_caller_identity" "current" {}


data "aws_ssm_parameter" "github_token" {
  name = "GITHUB_TOKEN"
}

data "aws_ssm_parameter" "webhook_token" {
  name = "WEBHOOK_TOKEN"
}

data "aws_ssm_parameter" "terraform_required_version" {
  name = "TERRAFORM_VERSION"
}

locals {
  github_webhook_event       = "push"
  pipeline_branch            = terraform.workspace
  github_filter_json_path    = "$.ref"
  github_filter_match_equals = "refs/heads/{Branch}"
}


/*
  --- SSM Paramters ---
*/

/*
  --- Module(s) ---
*/

module "iam" {
  source                     = "./modules/iam"
  tags                       = var.tags
  project_name               = var.repository_name
  codebuild_build_stage_arn  = aws_codebuild_project.build.arn
  codebuild_deploy_stage_arn = aws_codebuild_project.deploy.arn
}

/*
  --- Cloudwatch event trigger ---
*/

resource "aws_cloudwatch_event_rule" "rule" {
  name_prefix         = "${var.tags.ProjectName}-${terraform.workspace}"
  schedule_expression = "cron(30 09 * * ? *)"
  description         = "Nightly pipeline kickoff rule"
  tags                = var.tags
}

resource "aws_cloudwatch_event_target" "target" {
  rule     = aws_cloudwatch_event_rule.rule.id
  arn      = aws_codepipeline.pipeline.arn
  role_arn = module.iam.pipeline_role_arn
}

/*
  --- Codepipeline ---
*/

resource "aws_codepipeline" "pipeline" {
  name     = "${var.tags.ProjectName}-${terraform.workspace}"
  role_arn = module.iam.pipeline_role_arn

  artifact_store {
    location = aws_s3_bucket.pipeline_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["${var.tags.ProjectName}-source-artifact-${terraform.workspace}"]

      configuration = {
        Owner  = var.github_org
        Repo   = var.repository_name
        Branch = local.pipeline_branch

        PollForSourceChanges = false

        OAuthToken = data.aws_ssm_parameter.github_token.value
      }
    }
  }

  stage {
    name = "ExecuteTerraform"

    action {
      input_artifacts  = ["${var.tags.ProjectName}-source-artifact-${terraform.workspace}"]
      output_artifacts = ["${var.tags.ProjectName}-plan-artifact-${terraform.workspace}"]
      name             = "CreatePlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      run_order        = 1

      configuration = {
        ProjectName = aws_codebuild_project.build.name
      }
    }

    action {
      name      = "ApprovePlan"
      category  = "Approval"
      provider  = "Manual"
      owner     = "AWS"
      version   = "1"
      run_order = 2
      configuration = {
        CustomData         = "View the previous stage's output to review the Terraform Plan"
        ExternalEntityLink = "https://${var.region}.console.aws.amazon.com/codesuite/codebuild/projects/${var.tags.ProjectName}-Build-${terraform.workspace}/history?region=${var.region}"
      }
    }

    action {
      input_artifacts = ["${var.tags.ProjectName}-plan-artifact-${terraform.workspace}"]
      name            = "ApplyPlan"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      run_order       = 3

      configuration = {
        ProjectName = aws_codebuild_project.deploy.name
      }
    }
  }

  depends_on = [module.iam.pipeline_role_arn]
}

/*
  --- CodeBuild Project(s) ---
*/

resource "aws_codebuild_project" "build" {
  name          = "${var.tags.ProjectName}-Build-${terraform.workspace}"
  description   = "Install, test, lint and zip for Code"
  build_timeout = "15"
  service_role  = module.iam.codebuild_build_stage_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "hashicorp/terraform:light"
    type         = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
    buildspec = templatefile("${path.root}/../../buildspecs/buildspec-plan.yml", {
      tf_workspace    = terraform.workspace
      github_token    = data.aws_ssm_parameter.github_token.value
      repository_name = var.repository_name
    })
  }

  tags = merge(var.tags, map("Environment", "${terraform.workspace}", "Role", "CodeBuild"))
}

resource "aws_codebuild_project" "deploy" {
  name          = "${var.tags.ProjectName}-Terraform-${terraform.workspace}"
  description   = "Terraform init, workspace and apply"
  build_timeout = "50"
  service_role  = module.iam.codebuild_deploy_stage_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "hashicorp/terraform:light"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
    environment_variable {
      name  = "GIT_ASKPASS"
      value = "/set_git_pass.sh"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = templatefile("${path.root}/../../buildspecs/buildspec-apply.yml", {
      tf_workspace       = terraform.workspace
      tf_workspace_lower = lower(terraform.workspace)
      repository_name    = var.repository_name
      project_name       = lower(var.tags.ProjectName)
      github_token       = data.aws_ssm_parameter.github_token.value
    })
  }

  tags = merge(var.tags, map("Environment", "${terraform.workspace}", "Role", "CodeBuild"))
}


/*
    --- Webhook ---
*/

resource "aws_codepipeline_webhook" "pipeline_webhook" {
  name            = "${var.tags.ProjectName}-${terraform.workspace}"
  authentication  = "GITHUB_HMAC"
  target_action   = "Source"
  target_pipeline = aws_codepipeline.pipeline.name

  authentication_configuration {
    secret_token = data.aws_ssm_parameter.webhook_token.value
  }

  filter {
    json_path    = local.github_filter_json_path
    match_equals = local.github_filter_match_equals
  }

  tags = var.tags
}

resource "github_repository_webhook" "repo_webhook" {
  repository = var.repository_name
  configuration {
    url          = aws_codepipeline_webhook.pipeline_webhook.url
    content_type = "json"
    insecure_ssl = true
    secret       = data.aws_ssm_parameter.webhook_token.value
  }

  events = [local.github_webhook_event]
}

/*
    --- S3 Buckets ---
*/
resource "aws_s3_bucket" "pipeline_bucket" {
  bucket        = "${lower(var.tags.ProjectName)}-${terraform.workspace}-ppln"
  acl           = "private"
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "pipeline_bucket_access" {
  bucket = aws_s3_bucket.pipeline_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
