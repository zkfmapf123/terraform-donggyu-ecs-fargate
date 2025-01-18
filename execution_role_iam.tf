################################################## Resource ##################################################
resource "aws_iam_role" "execution_role" {
  name = lookup(var.execution_role_attr, "name")

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

data "aws_iam_policy" "defined_execution_policy" {
  name = "AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_execution_policy" {
  name   = "${var.execution_role_attr.name}-ecs-execution-policy"
  policy = jsonencode(lookup(var.execution_role_attr, "policy"))
}

resource "aws_iam_role_policy_attachment" "execution_policy_attach" {
  for_each = {
    for i, v in [data.aws_iam_policy.defined_execution_policy, aws_iam_policy.ecs_execution_policy] :
    i => v
  }


  role       = aws_iam_role.execution_role.name
  policy_arn = each.value.arn
}
