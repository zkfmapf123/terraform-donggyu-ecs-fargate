resource "aws_security_group" "ecs_sg" {
  name        = "test-ecs-sg"
  description = "test-ecs-sg"
  vpc_id      = "vpc-0be5e4795b7e66a4f"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "ecs" {
  source = "../../"

  is_use_alb = false

  task_role_attr = {
    name = "test-task-role"
    policy = {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : ["s3:*", "logs:CreateLogGroup"],
          "Resource" : "*"
        }
      ]
    }
  }

  execution_role_attr = {
    name = "test-execution-role"
    policy = {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : ["s3:*", "logs:CreateLogGroup"],
          "Resource" : "*"
        }
      ]
    }
  }

  ecr_attr = {
    is_enable = true
    name      = "test"
    env       = "dev"
  }

  ecs_attr = {
    ecs_name         = "test"
    ecs_env          = "dev"
    ecs_port         = 3000
    ecs_hard_cpu     = 256
    ecs_hard_mem     = 512
    ecs_image_arn    = "public.ecr.aws/p2t6u4a0/zent-utils:latest"
    ecs_os_system    = "LINUX"
    ecs_architecture = "ARM64"
    ecs_cluster      = "test-cluster"
  }

  ecs_network_attr = {
    ecs_is_public_ip = true
    ecs_subnet_ids   = ["subnet-096272491365decec", "subnet-0ded2f9aa6b8e37d0"]
    ecs_sg_ids       = [aws_security_group.ecs_sg.id]
    ecs_vpc_id       = "vpc-0be5e4795b7e66a4f"
  }
}
