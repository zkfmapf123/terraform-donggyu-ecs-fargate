################################################## Resource ##################################################
resource "aws_ecr_repository" "ecr_repository" {
  count = lookup(var.ecr_attr, "is_enable") ? 1 : 0

  name                 = "${var.ecr_attr.name}/${var.ecr_attr.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "ecr_lifecycle" {
  count = lookup(var.ecr_attr, "is_enable") ? 1 : 0

  repository = aws_ecr_repository.ecr_repository[0].name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep only the latest 20 images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 20
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
