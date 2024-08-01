# ------------------------------------
# ECS用IAMロール
# ------------------------------------
resource "aws_iam_role" "ecs_roles" {
  count = 2
  name  = "${var.project}-${var.env}-${element(["ECSTaskExecutionRole", "ECSTaskRole"], count.index)}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policies" {
  count      = length(local.execution_role_policies)
  role       = aws_iam_role.ecs_roles[0].name
  policy_arn = element(local.execution_role_policies, count.index)
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policies" {
  count      = length(local.task_role_policies)
  role       = aws_iam_role.ecs_roles[1].name
  policy_arn = element(local.task_role_policies, count.index)
}

# ------------------------------------
# codepipeline用IAMロール
# ------------------------------------
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project}-${var.env}-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "codepipeline_custom_policy" {
  name   = "${var.project}-${var.env}-codepipeline-custom-policy"
  role   = aws_iam_role.codepipeline_role.id
  policy = file("./modules/iam_role/custom_policy_json/codepipeline_custom_policy.json")
}

# ------------------------------------
# CodeBuild用IAMロール
# ------------------------------------
resource "aws_iam_role" "codebuild_role" {
  name = "${var.project}-${var.env}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_managed_policies" {
  for_each = toset(local.codebuild_policies)

  role       = aws_iam_role.codebuild_role.name
  policy_arn = each.value
}
