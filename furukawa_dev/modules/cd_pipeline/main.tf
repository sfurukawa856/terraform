resource "aws_codepipeline" "example" {
  name     = "${var.app_name}-${var.env}-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipeline_bucket.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.example.arn
        FullRepositoryId = "my-organization/example"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name      = "${var.app_name}-${var.env}-web"
      category  = "Deploy"
      owner     = "AWS"
      provider  = "ECS"
      version   = "1"
      run_order = 1
      configuration = {
        ClusterName = "${var.app_name}-${var.env}-web-cluster"
        ServiceName = "${var.app_name}-${var.env}-webService"
      }
      input_artifacts  = ["BuildArtifact"]
      output_artifacts = []
    }
  }
}

resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })
}

resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.app_name}-${var.env}-codepipeline-bucket"
}
