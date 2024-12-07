######################################################################################################### ECS

variable "ecr_attr" {

  default = {
    is_enable = true
    name      = ""
    env       = ""
  }
}

variable "ecs_attr" {
  description = "ecs 속성입니다"

  default = {
    ecs_name         = ""
    ecs_env          = ""
    ecs_port         = 3000
    ecs_hard_cpu     = 256
    ecs_hard_mem     = 512
    ecs_image_arn    = "public.ecr.aws/p2t6u4a0/zent-utils:latest"
    ecs_os_system    = "LINUX"
    ecs_architecture = "arm64"
    ecs_cluster      = ""
  }
}

variable "ecs_network_attr" {
  description = "ecs에 네트워크 속성입니다"

  default = {
    ecs_is_public_ip     = false
    ecs_subnet_ids       = []
    ecs_sg_ids           = []
    ecs_vpc_id           = ""
    ecs_443_listener_arn = ""
    ecs_priority         = 0
  }
}

variable "ecs_health_check" {
  description = "ecs tg에 heatlhcheck 속성입니다"

  default = {
    path                 = "/ping"
    port                 = 3000
    protocol             = "HTTP"
    healthy_threshold    = 3
    unhealthy_threshold  = 3
    matcher              = "200-301"
    timeout              = 30
    internal             = 40 ## greater than timeout
    deregistration_delay = 60
  }
}

variable "ecs_autosacling_attr" {
  description = "(Optional) AutoScaling 옵션입니다"

  default = {
    is_enable = false
    as_range  = [1, 10]
    cpu = {
      value        = 60
      in_cooldown  = 300
      out_cooldown = 300
    }

    mem = {
      value        = 70
      in_cooldown  = 300
      out_cooldown = 300
    }

    req = {
      value        = 10000 // x >= 10000
      in_cooldown  = 300
      out_cooldown = 300
      ## app/<load-balancer-name>/<load-balancer-id>/targetgroup/<target-group-name>/<target-group-id>
      appautoscaling_suffix = ""
    }
  }
}

######################################################################################################### IAM
variable "task_role_attr" {
  description = "ECS Task 실행역할 입니다. (실질적인 Resource 접근 허용 / 거부 정책)"

  default = {
    name   = ""
    policy = {}
  }
}

variable "execution_role_attr" {
  description = "ECS의 실행역할 입니다."

  default = {
    name   = ""
    policy = {}
  }
}
