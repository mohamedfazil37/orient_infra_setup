variable "repo_names" {
  type = list(string)
}

variable "buildspec_paths" {
  type = map(string)
}

variable "artifact_bucket_arn" {
  type = string
}
