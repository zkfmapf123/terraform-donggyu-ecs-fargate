################################################## Resource ##################################################
resource "aws_ecs_task_definition" "task_def" {
  family                   = "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-task-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = lookup(var.ecs_attr, "ecs_hard_cpu")
  memory = lookup(var.ecs_attr, "ecs_hard_mem")

  execution_role_arn = aws_iam_role.execution_role.arn
  task_role_arn      = aws_iam_role.task_role.arn

  // 초기세팅만 진행
  container_definitions = jsonencode([
    {
      name      = "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-svc"
      image     = "public.ecr.aws/p2t6u4a0/zent-utils:latest"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = lookup(var.ecs_attr, "ecs_port")
          hostPort      = lookup(var.ecs_attr, "ecs_port")
        }
      ],
      environment = [
        {
          name  = "PORT"
          value = tostring(lookup(var.ecs_attr, "ecs_port"))
        },
        {
          name  = "HEALTH_ROUTE"
          value = "ping"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group" : "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}",
          "awslogs-create-group" : "true"
          "awslogs-region" : "ap-northeast-2",
          "awslogs-stream-prefix" : "[ecs-service]"
        }
      }
    },
  ])

  runtime_platform {
    operating_system_family = lookup(var.ecs_attr, "ecs_os_system")
    cpu_architecture        = lookup(var.ecs_attr, "ecs_arch")
  }

  lifecycle {
    ignore_changes = [container_definitions]
  }

  tags = {

  }
}

#################################### Target Group + Listener Rule ####################################
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-tg"
  port        = lookup(var.ecs_attr, "ecs_port")
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = lookup(var.ecs_network_attr, "ecs_vpc_id")

  health_check {
    path                = lookup(var.ecs_health_check, "path")
    port                = lookup(var.ecs_health_check, "port")
    protocol            = lookup(var.ecs_health_check, "protocol")
    healthy_threshold   = lookup(var.ecs_health_check, "healthy_threshold")
    unhealthy_threshold = lookup(var.ecs_health_check, "unhealthy_threshold")
    matcher             = lookup(var.ecs_health_check, "matcher")
    timeout             = lookup(var.ecs_health_check, "timeout")
    interval            = lookup(var.ecs_health_check, "interval")
  }

  deregistration_delay = lookup(var.ecs_health_check, "deregistration_delay")

}

resource "aws_lb_listener_rule" "ecs_listener_rule" {
  listener_arn = lookup(var.ecs_network_attr, "ecs_443_listener_arn")
  priority     = lookup(var.ecs_network_attr, "ecs_priority")

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = lookup(var.ecs_network_attr, "ecs_host_header")
    }
  }
}


#################################### ECS Service ####################################
resource "aws_ecs_service" "ecs_svc" {
  launch_type = "FARGATE"

  name            = "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-svc"
  cluster         = lookup(var.ecs_attr, "ecs_cluster")
  task_definition = aws_ecs_task_definition.task_def.id

  propagate_tags = "SERVICE" ## ECS Service에 구성된 태그 전파
  # health_check_grace_period_seconds = 

  desired_count           = 1
  enable_execute_command  = true
  enable_ecs_managed_tags = true

  network_configuration {
    assign_public_ip = lookup(var.ecs_network_attr, "ecs_is_public_ip")
    subnets          = lookup(var.ecs_network_attr, "ecs_subnet_ids")
    security_groups  = lookup(var.ecs_network_attr, "ecs_sg_ids")
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "${var.ecs_attr.ecs_name}-${var.ecs_attr.ecs_env}-svc"
    container_port   = lookup(var.ecs_attr, "ecs_port")
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  deployment_controller {
    type = "ECS"
  }

  tags = {

  }

  lifecycle {
    ignore_changes = [task_definition]
  }

}