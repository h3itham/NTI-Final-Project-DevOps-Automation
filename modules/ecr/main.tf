# CREATE REGISTRY FOR PROJECT 
resource "aws_ecr_repository" "ecr_repo" {
  name = var.repository_name
}