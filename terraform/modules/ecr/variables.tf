variable "environment" {
  default = "root"
}

variable "app" {
  default = "scan-image"
}

variable "tag" {
  description = "Tag to use for deployed Docker image"
  type        = string
  default     = "latest"
}

variable "image_name" {
  description = "Name to use for deployed Docker image"
  type        = string
  default     = "ecs-task/scan-image"
}