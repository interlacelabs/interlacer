variable "region" {
  default = "us-east-1"
  type = string
  description = "The region you want to deploy the infrastructure in"
}

variable "app" {
  default = "app"
  type = string
  description = "The name of the app"
}

variable "environment" {
  default = "dev"
  type = string
  description = "The name of the environment"
}

variable "logs_retention_in_days" {
  default = 1
  type = string
  description = "The number of days for log retention"
}

variable "tags" {
  type = map

  default = {
    owner = "dev-to"
  }
}

# backend variables
variable "bucket" {}
variable "key" {}
variable "dynamodb_table" {}
variable "workspace_key_prefix" {}
variable "profile" {}