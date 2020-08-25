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
  description = "The list of tags required for AWS assets"
}

variable "github_org" {
  type        = string
  description = "Github organization or user that owns the payload repo"
  default     = "chrilebl"
}
