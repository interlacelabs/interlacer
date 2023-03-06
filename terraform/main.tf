provider "aws" {
  region = var.region  
  profile = var.profile
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/${var.app}-${var.environment}"
  retention_in_days = var.logs_retention_in_days
  tags              = var.tags
}

module "vpc" {
  source = "./modules/vpc"
}


resource "aws_ssm_parameter" "ecs_subnet_a" {
  name  = "ecs_subnet_a"
  type  = "String"
  value = module.vpc.ecs_subnet_a.id
}

resource "aws_ssm_parameter" "ecs_subnet_b" {
  name  = "ecs_subnet_b"
  type  = "String"
  value = module.vpc.ecs_subnet_b.id
}

module "ecr" {
  source = "./modules/ecr"
  image_name= "ecs-task/scan-image"
}

module "docker" {
  source = "./modules/docker"

  tag = "latest"
  image_name = "ecs-task/scan-image"
  source_path = "${path.module}/scratch-app"
  ecr_repository_url = module.ecr.ecr_repository.repository_url
  ecr_authorization_token = module.ecr.ecr_authorization_token
}

module "ecr_alpine" {
  source = "./modules/ecr"
  image_name= "ecs-task/scan-image-alpine"
}

module "docker_alpine" {
  source = "./modules/docker"

  tag = "latest"
  image_name = "ecs-task/scan-image-alpine"
  source_path = "${path.module}/alpine-app"
  ecr_repository_url = module.ecr_alpine.ecr_repository.repository_url
  ecr_authorization_token = module.ecr_alpine.ecr_authorization_token
}

module "ecs" {
  source = "./modules/ecs"
  ecs_sg = module.vpc.ecs_sg
  ecs_subnet_a = module.vpc.ecs_subnet_a
  ecs_subnet_b = module.vpc.ecs_subnet_b
  ecs_subnet_c = module.vpc.ecs_subnet_c
  ecs_log_group = aws_cloudwatch_log_group.logs.name
  ecs_log_region = var.region
  docker_image = "${module.ecr.ecr_repository.repository_url}:latest"
}
