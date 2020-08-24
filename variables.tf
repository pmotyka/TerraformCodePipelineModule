variable "region" {
  type        = string
  description = "The region for AWS assets"
}

variable "repository_name" {
  type        = string
  description = "The name of the repository being built with this pipeline"
}

variable "tags" {
  type        = map
  description = "The list of PG&E tags required for AWS assets"
}

variable "node_env" {
  type        = string
  description = "The node_env envar passed to buildspec_terraform"
  default     = "dev"
}

variable "use_custom_image" {
  type        = bool
  description = "Switch for using terrform docker image vs custom docker image"
  default     = true
}

variable "aws_account" {
  type        = string
  description = "Aws account name, Dev, QA, Prod"
}

variable "github_org" {
  type        = string
  description = "Github organization or user that owns the repo"
  default     = "chrilebl"
}
