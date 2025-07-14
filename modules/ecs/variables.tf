variable "cluster_name" {}
variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "service_sg_id" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "service_configs" {
  type = map(object({
    image         = string
    port          = number
    tg_arn        = string
    container_cpu = number
    container_mem = number
  }))
}
