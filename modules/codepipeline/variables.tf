variable "pipeline_name" {}
variable "artifact_bucket" {}
variable "github_repo" {}
variable "github_owner" {}
variable "github_branch" {}
variable "github_token" {}
variable "ecs_cluster_name" {}
variable "service_names" {
  type = list(string)
}
