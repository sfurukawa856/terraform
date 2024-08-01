locals {
  # ------------------------------------
  # ECS用IAMロールにアタッチするマネージドポリシー
  # ------------------------------------
  execution_role_base_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
  execution_role_policies = concat(
    local.execution_role_base_policies,
    var.execution_role_policies
  )

  task_role_base_policies = [
    "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  ]
  task_role_policies = concat(
    local.task_role_base_policies,
    var.task_role_policies
  )

  # ------------------------------------
  # CodeBuild用IAMロールにアタッチするマネージドポリシー
  # ------------------------------------
  codebuild_policies = [
    "arn:aws:iam::aws:policy/AWSCodeBuildAdminAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]
}
