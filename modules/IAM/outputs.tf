output "execution_role_arn" {
  value = aws_iam_role.ecs_execution.arn
}

output "task_role_arn" {
  value = aws_iam_role.ecs_task.arn
}
output "ecs_execution_policy_arn" {
  value = aws_iam_role_policy_attachment.ecs_execution_policy.policy_arn
}