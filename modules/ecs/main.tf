# modules/ecs/main.tf

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
}

locals {
  services = var.service_configs
}

resource "aws_ecs_task_definition" "this" {
  for_each = local.services

  family                   = "${each.key}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.container_cpu
  memory                   = each.value.container_mem
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = each.key,
      image     = each.value.image,
      essential = true,
      portMappings = [
        {
          containerPort = each.value.port
          hostPort      = each.value.port
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "this" {
  for_each            = local.services
  name               = each.key
  cluster            = aws_ecs_cluster.this.id
  task_definition    = aws_ecs_task_definition.this[each.key].arn
  desired_count      = 1
  launch_type        = "FARGATE"
  platform_version   = "LATEST"

  network_configuration {
    subnets          = var.private_subnets
    assign_public_ip = false
    security_groups  = [var.service_sg_id]
  }

  load_balancer {
    target_group_arn = each.value.tg_arn
    container_name   = each.key
    container_port   = each.value.port
  }

  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_ecs_service_discovery_service" "this" {
  for_each = local.services

  name = each.key
  dns_config {
    namespace_id = var.namespace_id
    routing_policy = "MULTIVALUE"
    dns_records {
      ttl  = 60
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }

  depends_on = [aws_ecs_service.this]
} 