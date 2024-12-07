################################################## Resource ##################################################
resource "aws_iam_role" "task_role" {
  name = lookup(var.task_role_attr, "name")

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

resource "aws_iam_policy" "defined_ecs_task_policy" {
  name = "${var.task_role_attr.name}-defined-policy"
  policy = jsonencode({
    "Version" : "2012-10-17"
    "Statement" : [
      {
        "Sid" : "DenyIAM"
        "Action" : "iam:*",
        "Resource" : "*",
        "Effect" : "Deny"
      },
      {
        "Action" : [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenDataChannel",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ] }
  )

}

resource "aws_iam_policy" "ecs_task_policy" {
  name   = "${var.task_role_attr.name}-ecs-task-policy"
  policy = jsonencode(lookup(var.task_role_attr, "policy"))
}

resource "aws_iam_role_policy_attachment" "task_policy_attach" {
  for_each = {
    for i, v in [aws_iam_policy.ecs_task_policy, aws_iam_policy.defined_ecs_task_policy] :
    i => v
  }

  role       = aws_iam_role.task_role.name
  policy_arn = each.value.arn
}