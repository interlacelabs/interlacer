resource "aws_ecs_cluster" "dev_to" {
  name = "dev-to"

  setting {
    name = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "dev-to"
    Project = "dev-to"
    Billing = "dev-to"
  }
}

resource "aws_ecs_cluster_capacity_providers" "dev_to" {
  cluster_name = aws_ecs_cluster.dev_to.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

data "template_file" "task_definition" {
  template = jsonencode([
    {
      "command": ["/app/awesome-prog"],
      "cpu": 512,
      "environment": [
        {
          "name": "AUTHOR",
          "value": "dev-to"
        }
      ],
      "memory": 1024,
      "image": "$${DOCKER_IMAGE}",
      "essential": true,
      "name": "site",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "$${LOG_GROUP}",
          "awslogs-region": "$${LOG_REGION}",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ])
  vars = {
    LOG_GROUP = "${var.ecs_log_group}"
    LOG_REGION = "${var.ecs_log_region}"
    DOCKER_IMAGE = "${var.docker_image}"
  }
}

resource "aws_ecs_task_definition" "dev_to" {
  family = "dev-to"
  container_definitions = data.template_file.task_definition.rendered

  execution_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
  task_role_arn = aws_iam_role.app_role.arn

  network_mode = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  memory = "1024"
  cpu = "512"

  tags = {
    Name = "dev-to"
    Project = "dev-to"
    Billing = "dev-to"
  }
}

# resource "aws_ecs_service" "dev_to" {
#   name = "dev-to"
#   cluster = aws_ecs_cluster.dev_to.id
#   task_definition = aws_ecs_task_definition.dev_to.arn
#   desired_count = 1
#   launch_type = "FARGATE"
#   platform_version = "1.4.0"

#   lifecycle {
#     ignore_changes = [
#       desired_count]
#   }

#   network_configuration {
#     subnets = [
#       var.ecs_subnet_a.id,
#       var.ecs_subnet_b.id,
#       var.ecs_subnet_c.id]
#     security_groups = [
#       var.ecs_sg.id]
#     assign_public_ip = true
#   }

#   load_balancer {
#     target_group_arn = var.ecs_target_group.arn
#     container_name = "site"
#     container_port = 80
#   }
# }
