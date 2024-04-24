# THE URL OF THE ECR REPOSITORY.
output "repository_url" {
  value       = aws_ecr_repository.ecr_repo.repository_url
}