variable "namespace" {
  type        = string
  description = "The global namespace for your infra"
  default     = "chrilebl"
}

variable "account_name" {
  type        = string
  description = "The name of the account dev/test/prod etc"
}
