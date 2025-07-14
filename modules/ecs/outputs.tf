output "ecs_cluster_id" {
  value = aws_ecs_cluster.this.id
}

output "ecs_service_names" {
  value = [for s in aws_ecs_service.this : s.name]
}

output "ecs_service_arns" {
  value = [for s in aws_ecs_service.this : s.id]
}

output "ecs_task_definition_arns" {
  value = [for t in aws_ecs_task_definition.this : t.arn]
}
