variable "repo_names" {
  description = "List of microservice repository names."
  type        = list(string)
}

variable "artifact_bucket_name" {
  description = "S3 bucket name where artifacts are stored."
  type        = string
}

variable "github_owner" {
  description = "GitHub username or organization that owns the repositories."
  type        = string
}

variable "github_token" {
  description = "GitHub OAuth token for CodePipeline access."
  type        = string
  sensitive   = true
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster to deploy the services to."
  type        = string
}

variable "namespace_id" {
  description = "ID of the namespace to use for service discovery."
  type        = string
}