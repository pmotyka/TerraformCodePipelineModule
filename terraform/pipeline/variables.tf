variable "repository_name" {
  type        = string
  description = "The name of the repository that Terraform is deploying to AWS"
}

variable "aws_account" {
  type        = string
  description = "Aws account name, Dev, QA, Prod"
}
