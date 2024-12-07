<!-- BEGIN_TF_DOCS -->
## Description

- ECS Fargate를 생성하는 모듈입니다.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.ecs_target_cpu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.ecs_target_mem](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.ecs_target_req](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.ecs_app_autoscaling_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecr_lifecycle_policy.ecr_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.ecr_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_service.ecs_svc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task_def](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_policy.defined_ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ecs_task_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.execution_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.task_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb_listener_rule.ecs_listener_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.ecs_tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_iam_policy.defined_execution_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ecr_attr"></a> [ecr\_attr](#input\_ecr\_attr) | n/a | `map` | <pre>{<br>  "env": "",<br>  "is_enable": true,<br>  "name": ""<br>}</pre> | no |
| <a name="input_ecs_attr"></a> [ecs\_attr](#input\_ecs\_attr) | ecs 속성입니다 | `map` | <pre>{<br>  "ecs_architecture": "arm64",<br>  "ecs_cluster": "",<br>  "ecs_env": "",<br>  "ecs_hard_cpu": 256,<br>  "ecs_hard_mem": 512,<br>  "ecs_image_arn": "public.ecr.aws/p2t6u4a0/zent-utils:latest",<br>  "ecs_name": "",<br>  "ecs_os_system": "LINUX",<br>  "ecs_port": 3000<br>}</pre> | no |
| <a name="input_ecs_autosacling_attr"></a> [ecs\_autosacling\_attr](#input\_ecs\_autosacling\_attr) | (Optional) AutoScaling 옵션입니다 | `map` | <pre>{<br>  "as_range": [<br>    1,<br>    10<br>  ],<br>  "cpu": {<br>    "in_cooldown": 300,<br>    "out_cooldown": 300,<br>    "value": 60<br>  },<br>  "is_enable": false,<br>  "mem": {<br>    "in_cooldown": 300,<br>    "out_cooldown": 300,<br>    "value": 70<br>  },<br>  "req": {<br>    "appautoscaling_suffix": "",<br>    "in_cooldown": 300,<br>    "out_cooldown": 300,<br>    "value": 10000<br>  }<br>}</pre> | no |
| <a name="input_ecs_health_check"></a> [ecs\_health\_check](#input\_ecs\_health\_check) | ecs tg에 heatlhcheck 속성입니다 | `map` | <pre>{<br>  "deregistration_delay": 60,<br>  "healthy_threshold": 3,<br>  "internal": 40,<br>  "matcher": "200-301",<br>  "path": "/ping",<br>  "port": 3000,<br>  "protocol": "HTTP",<br>  "timeout": 30,<br>  "unhealthy_threshold": 3<br>}</pre> | no |
| <a name="input_ecs_network_attr"></a> [ecs\_network\_attr](#input\_ecs\_network\_attr) | ecs에 네트워크 속성입니다 | `map` | <pre>{<br>  "ecs_443_listener_arn": "",<br>  "ecs_is_public_ip": false,<br>  "ecs_priority": 0,<br>  "ecs_sg_ids": [],<br>  "ecs_subnet_ids": [],<br>  "ecs_vpc_id": ""<br>}</pre> | no |
| <a name="input_execution_role_attr"></a> [execution\_role\_attr](#input\_execution\_role\_attr) | ECS의 실행역할 입니다. | `map` | <pre>{<br>  "name": "",<br>  "policy": {}<br>}</pre> | no |
| <a name="input_task_role_attr"></a> [task\_role\_attr](#input\_task\_role\_attr) | ECS Task 실행역할 입니다. (실질적인 Resource 접근 허용 / 거부 정책) | `map` | <pre>{<br>  "name": "",<br>  "policy": {}<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecr_name"></a> [ecr\_name](#output\_ecr\_name) | n/a |
| <a name="output_ecs_execution_role_arn"></a> [ecs\_execution\_role\_arn](#output\_ecs\_execution\_role\_arn) | n/a |
| <a name="output_ecs_task_def"></a> [ecs\_task\_def](#output\_ecs\_task\_def) | n/a |
| <a name="output_ecs_task_role_arn"></a> [ecs\_task\_role\_arn](#output\_ecs\_task\_role\_arn) | n/a |
| <a name="output_ecs_tg_id"></a> [ecs\_tg\_id](#output\_ecs\_tg\_id) | n/a |
| <a name="output_ecs_tg_name"></a> [ecs\_tg\_name](#output\_ecs\_tg\_name) | n/a |
<!-- END_TF_DOCS -->