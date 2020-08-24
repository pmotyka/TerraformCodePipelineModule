/*
    --- Policy Documents ---
*/

data "aws_iam_policy_document" "codepipeline_policy_document" {
  // APIGW Permissions
  statement {
    actions = [
      "apigateway:*"
    ]

    resources = [
      "*",
    ]
  }

  // CodePipeline Permissions
  statement {
    actions = [
      "codepipeline:StartPipelineExecution",
    ]

    resources = [
      "*",
    ]
  }

  // S3 Permissions
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject",
    ]

    resources = [
      "*",
    ]
  }

  // CodeBuild Permissions
  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = [
      var.codebuild_build_stage_arn,
      var.codebuild_deploy_stage_arn,
    ]
  }

  // ECS and Logs Permissions
  statement {
    actions = [
      "logs:*",
      "ecr:DescribeImages",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "codebuild_build_stage_policy_document" {
  // APIGW Permissions
  statement {
    actions = [
      "apigateway:*"
    ]

    resources = [
      "*",
    ]
  }

  // KMS Permissions
  statement {
    actions = [
      "kms:*"
    ]

    resources = [
      "*",
    ]
  }

  // Lambda Permissions
  statement {
    actions = [
      "lambda:*",
    ]

    resources = [
      "*",
    ]
  }

  // S3 Permissions
  statement {
    actions = [
      "s3:CreateBucket",
      "s3:Get*",
      "s3:ListAllMyBuckets",
      "s3:ListBucket",
      "s3:PutBucketPolicy",
      "s3:PutObject",
    ]

    resources = [
      "*",
    ]
  }

  // Logs Permissions
  statement {
    actions = [
      "logs:*",
    ]

    resources = [
      "*",
    ]
  }

  // ECR Permissions
  statement {
    actions = [
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListTagsForResource",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "secretsmanager:DescribeSecret",
    ]

    resources = [
      "*"
    ]
  }

  // DynamoDB Permissions
  statement {
    actions = [
      "dynamodb:DeleteItem",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]

    resources = [
      "*",
    ]
  }


  // EC2 Permissions
  statement {
    actions = [
      "ec2:Describe*",
    ]

    resources = [
      "*",
    ]
  }

  // SecretsManager Permissions
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "*",
    ]
  }

  // IAM Permissions
  statement {
    actions = [
      "iam:*",
    ]

    resources = [
      "*",
    ]
  }

  // ACM Permission
  statement {
    actions = [
      "acm:GetCertificate"
    ]

    resources = [
      "*",
    ]
  }

  // Systems Manager Permission
  statement {
    actions = [
      "ssm:GetParameters"
    ]

    resources = [
      "*",
    ]
  }

  // Events
  statement {
    actions = [
      "events:DeleteRule",
      "events:DescribeRule",
      "events:EnableRule",
      "events:ListTargetsByRule",
      "events:ListTagsForResource",
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "events:TagResource",
    ]

    resources = [
      "*",
    ]
  }
}

data "aws_iam_policy_document" "codebuild_deploy_stage_policy_document" {

  // ACM Permission
  statement {
    actions = [
      "acm:DeleteCertificate",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:ListTagsForCertificate",
      "acm:RequestCertificate"
    ]

    resources = [
      "*",
    ]
  }

  // AppSync
  statement {
    actions = [
      "appsync:CreateGraphqlApi",
      "appsync:CreateResolver",
      "appsync:GetResolver",
      "appsync:DeleteResolver",
      "appsync:DeleteGraphqlApi",
      "appsync:GetDataSource",
      "appsync:DeleteDataSource",
      "appsync:GetGraphqlApi",
      "appsync:GetSchemaCreationStatus",
      "appsync:StartSchemaCreation",
      "appsync:UpdateGraphqlApi",
      "appsync:CreateDataSource",
    ]
    resources = [
      "*",
    ]
  }

  // CloudTrail
  statement {
    actions = [
      "cloudtrail:Add*",
      "cloudtrail:Create*",
      "cloudtrail:Describe*",
      "cloudtrail:Get*",
      "cloudtrail:List*",
      "cloudtrail:LookupEvents",
      "cloudtrail:Put*",
      "cloudtrail:StartLogging",
      "cloudtrail:StopLogging",
      "cloudtrail:UpdateTrail",
    ]
    resources = [
      "*",
    ]
  }

  // Events
  statement {
    actions = [
      "events:DeleteRule",
      "events:DescribeRule",
      "events:EnableRule",
      "events:ListTargetsByRule",
      "events:ListTagsForResource",
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "events:TagResource",
    ]

    resources = [
      "*",
    ]
  }

  // S3 Permissions
  statement {
    actions = [
      "s3:*",
    ]

    resources = [
      "*",
    ]
  }

  // EC2 Permissions
  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:CreateTags",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteTags",
      "ec2:Describe*",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
    ]

    resources = [
      "*",
    ]
  }

  // ECS Permissions
  statement {
    actions = [
      "ecs:CreateCluster",
      "ecs:CreateService",
      "ecs:DeleteService",
      "ecs:DeleteTaskSet",
      "ecs:Describe*",
      "ecs:UntagResource",
      "ecs:UpdateService",
      "ecs:DeregisterTaskDefinition",
      "ecs:RegisterTaskDefinition",
    ]

    resources = [
      "*",
    ]
  }

  // Systems Manager Permission
  statement {
    actions = [
      "ssm:GetParameters"
    ]

    resources = [
      "*",
    ]
  }

  // KMS Permissions
  statement {
    actions = [
      "kms:*",
    ]

    resources = [
      "*",
    ]
  }

  // Logs Permissions
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DeleteLogGroup",
      "logs:DescribeLogGroups",
      "logs:ListTagsLogGroup",
      "logs:PutLogEvents",
      "logs:TagLogGroup",
      "logs:PutSubscriptionFilter",
      "logs:DescribeSubscriptionFilters",
      "logs:DeleteSubscriptionFilter"
    ]

    resources = [
      "*",
    ]
  }

  // ECR Permissions
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:CompleteLayerUpload",
      "ecr:CreateRepository",
      "ecr:DeleteRepository",
      "ecr:Describe*",
      "ecr:Get*",
      "ecr:InitiateLayerUpload",
      "ecr:List*",
      "ecr:Put*",
      "ecr:SetRepositoryPolicy",
      "ecr:TagResource",
      "ecr:UploadLayerPart",
      "ecr:UntagResource"
    ]

    resources = [
      "*",
    ]
  }

  // ELB Permissions
  statement {
    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:SetSecurityGroups",
    ]

    resources = [
      "*",
    ]
  }

  // IAM Permissions
  statement {
    actions = [
      "iam:*",
    ]

    resources = [
      "*",
    ]
  }

  // Lambda Permissions
  statement {
    actions = [
      "lambda:*"
    ]

    resources = [
      "*",
    ]
  }

  // Lambda Permissions
  statement {
    actions = [
      "apigateway:*"
    ]

    resources = [
      "*",
    ]
  }

  // DynamoDB Permissions
  statement {
    actions = [
      "dynamodb:Create*",
      "dynamodb:DeleteItem",
      "dynamodb:DeleteTable",
      "dynamodb:Describe*",
      "dynamodb:GetItem",
      "dynamodb:ListTagsOfResource",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:TagResource",
    ]

    resources = [
      "*",
    ]
  }

  // Route53 Permissions
  statement {
    actions = [
      "route53:GetHostedZone",
    ]

    resources = [
      "*",
    ]
  }

  // SQS Permissions
  statement {
    actions = [
      "sqs:*",
    ]

    resources = [
      "*",
    ]
  }

  // SNS Permissions
  statement {
    actions = [
      "sns:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      "*",
    ]
  }

  // STS Permissions

  statement {
    actions = [
      "sts:AssumeRole"
    ]

    resources = [
      "arn:aws:iam::686137062481:role/DCDNSCrossAccountRole",
    ]

  }
}

data "aws_iam_policy_document" "codepipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

/*
    --- IAM Policies ---
*/

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "${var.project_name}-pipeline-${terraform.workspace}"
  description = "A policy that allows the CodePipeline to execute"
  policy      = data.aws_iam_policy_document.codepipeline_policy_document.json
}

resource "aws_iam_policy" "codebuild_build_stage_policy" {
  name        = "${var.project_name}-build-${terraform.workspace}"
  description = "A policy that allows the CodeBuild build stage to execute"
  policy      = data.aws_iam_policy_document.codebuild_build_stage_policy_document.json
}

resource "aws_iam_policy" "codebuild_deploy_stage_policy" {
  name        = "${var.project_name}-deploy-${terraform.workspace}"
  description = "A policy that allows the CodeBuild deploy stage to execute"
  policy      = data.aws_iam_policy_document.codebuild_deploy_stage_policy_document.json
}

/*
    --- IAM Roles ---
*/

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.project_name}-Pipeline-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role_policy.json
  tags               = merge(var.tags, map("Name", "${var.project_name}-Pipeline-${terraform.workspace}", "Environment", "${terraform.workspace}", "Role", "IAM Role"))
}

resource "aws_iam_role" "codebuild_build_stage_role" {
  name               = "${var.project_name}-Build-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
  tags               = merge(var.tags, map("Name", "${var.project_name}-Build-${terraform.workspace}", "Environment", "${terraform.workspace}", "Role", "IAM Role"))
}

resource "aws_iam_role" "codebuild_deploy_stage_role" {
  name               = "${var.project_name}-Deploy-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role_policy.json
  tags               = merge(var.tags, map("Name", "${var.project_name}-Deploy-${terraform.workspace}", "Environment", "${terraform.workspace}", "Role", "IAM Role"))
}

/*
    --- Policy/Role Attachment ---
*/

resource "aws_iam_policy_attachment" "codepipeline_attach" {
  name       = "${var.project_name}-pipeline-${terraform.workspace}"
  roles      = [aws_iam_role.codepipeline_role.name]
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}

resource "aws_iam_policy_attachment" "codebuild_build_stage_attach" {
  name       = "${var.project_name}-build-${terraform.workspace}"
  roles      = [aws_iam_role.codebuild_build_stage_role.name]
  policy_arn = aws_iam_policy.codebuild_build_stage_policy.arn
}

resource "aws_iam_policy_attachment" "codebuild_deploy_stage_attach" {
  name       = "${var.project_name}-deploy-${terraform.workspace}"
  roles      = [aws_iam_role.codebuild_deploy_stage_role.name]
  policy_arn = aws_iam_policy.codebuild_deploy_stage_policy.arn
}

