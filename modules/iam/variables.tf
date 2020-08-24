variable "tags" {
  type        = map
  description = "The list of PG&E tags required for AWS assets"
}

variable "project_name" {
  type        = string
  description = "The name of the project"
}
variable "codebuild_build_stage_arn" {
  description = "The ARN of the build stage Codebuild used by codepipeline"
  type        = string
}

variable "codebuild_deploy_stage_arn" {
  description = "The ARN of the deploy stage Codebuild used by codepipeline"
  type        = string
}
