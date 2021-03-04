###
# Repo
###
resource "aws_ecr_repository" "ecr" {
  name = var.ecr_name
}
###
# Purge images older than 5 days
###
resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name
  policy = <<EOF
    {
        "rules": [
            {
                "rulePriority": 1,
                "description": "Purge images older than 5 days",
                "selection": {
                    "tagStatus": "any",
                    "countType": "sinceImagePushed",
                    "countUnit": "days",
                    "countNumber": 5
                },
                "action": {
                    "type": "expire"
                }
            }
        ]
    }
    EOF
}