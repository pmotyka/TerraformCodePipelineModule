output "pipeline_role_arn" {
  value      = aws_iam_role.codepipeline_role.arn
  depends_on = [aws_iam_policy_attachment.codepipeline_attach]
}

output "codebuild_build_stage_role_arn" {
  value = aws_iam_role.codebuild_build_stage_role.arn
}

output "codebuild_deploy_stage_role_arn" {
  value = aws_iam_role.codebuild_deploy_stage_role.arn
}
