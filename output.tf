output "ecr_name" {
  value = length(aws_ecr_repository.ecr_repository) > 0 ? aws_ecr_repository.ecr_repository[0].name : ""
}

output "ecs_execution_role_arn" {
  value = aws_iam_role.execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.task_role.arn
}

output "ecs_task_def" {
  value = aws_ecs_task_definition.task_def.container_definitions
}

output "ecs_tg_name" {
  value = aws_lb_target_group.ecs_tg.name
}

output "ecs_tg_id" {
  value = aws_lb_target_group.ecs_tg.id
}