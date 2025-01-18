locals {

  target_metric = {
    "cpu" : "ECSServiceAverageCPUUtilization",
    "mem" : "ECSServiceAverageMemoryUtilization",
    "req" : "ALBRequestCountPerTarget"
  }
}

resource "aws_appautoscaling_target" "ecs_app_autoscaling_policy" {
  count = lookup(var.ecs_autosacling_attr, "is_enable") ? 1 : 0

  min_capacity = lookup(var.ecs_autosacling_attr, "as_range")[0]
  max_capacity = lookup(var.ecs_autosacling_attr, "as_range")[1]

  resource_id        = "service/${var.ecs_attr.ecs_cluster}/${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-svc"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.ecs_svc]
  lifecycle {
    ignore_changes = [role_arn]
  }
}

resource "aws_appautoscaling_policy" "ecs_target_cpu" {
  count = lookup(var.ecs_autosacling_attr, "is_enable") ? 1 : 0

  name               = "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-AutoScaling-CPU"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = lookup(local.target_metric, "cpu")
    }

    target_value       = lookup(var.ecs_autosacling_attr.cpu, "value")
    disable_scale_in   = true
    scale_in_cooldown  = lookup(var.ecs_autosacling_attr.cpu, "in_cooldown")
    scale_out_cooldown = lookup(var.ecs_autosacling_attr.cpu, "out_cooldown")
  }
}

resource "aws_appautoscaling_policy" "ecs_target_mem" {
  count = lookup(var.ecs_autosacling_attr, "is_enable") ? 1 : 0

  name               = "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-AutoScaling-MEM"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = lookup(local.target_metric, "mem")
    }

    target_value       = lookup(var.ecs_autosacling_attr.mem, "value")
    disable_scale_in   = true
    scale_in_cooldown  = lookup(var.ecs_autosacling_attr.mem, "in_cooldown")
    scale_out_cooldown = lookup(var.ecs_autosacling_attr.mem, "out_cooldown")
  }
}

resource "aws_appautoscaling_policy" "ecs_target_req" {
  count = lookup(var.ecs_autosacling_attr, "is_enable") && var.is_use_alb ? 1 : 0

  name               = "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-AutoScaling-REQ"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_app_autoscaling_policy[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = lookup(local.target_metric, "req")
      resource_label         = "${lookup(var.ecs_autosacling_attr.req, "appautoscaling_suffix")}/targetgroup/${aws_lb_target_group.ecs_tg[0].name}/${regex(".*targetgroup/.+/([^/]+)$", aws_lb_target_group.ecs_tg[0].id)[0]}"
    }

    target_value       = lookup(var.ecs_autosacling_attr.req, "value")
    disable_scale_in   = true
    scale_in_cooldown  = lookup(var.ecs_autosacling_attr.req, "in_cooldown")
    scale_out_cooldown = lookup(var.ecs_autosacling_attr.req, "out_cooldown")
  }
}
