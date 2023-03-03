variable "tag" {
  description = "Tag to use for deployed Docker image"
  type        = string
}

variable "image_name" {
  description = "Name to use for deployed Docker image"
  type        = string
}

variable "source_path" {
  description = "Path to Docker image source"
  type        = string
}

variable ecr_repository_url {
    description = "ECR repository url"
    type = string
}

variable ecr_authorization_token {
    description = "Authorization token for ecr repo"
    type = string
}

variable "hash_script" {
  description = "Path to script to generate hash of source contents"
  type        = string
  default     = ""
}