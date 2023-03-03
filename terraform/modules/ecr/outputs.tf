output "ecr_repository" {
  value = aws_ecr_repository.repo
}

output "ecr_authorization_token" {
    value = data.aws_ecr_authorization_token.token.password
}