variable "image_tag" {
  description = "Docker image tag"
}

variable "ecr_repo" {
  description = "ECR repository URL"
}

variable "existing_execution_role_arn" {
  description = "ARN of an existing ECS task execution role"
  type        = string
}
