module "vpc" {
  source = "./modules/vpc"
  region = var.region
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}

module "aurora" {
  source = "./modules/aurora"
  db_username = var.db_username
  db_password = var.db_password
  private_subnets = module.vpc.private_subnets
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  target_group_port  = 3000 # Adjust to your app port
}

module "ecs" {
  source            = "./modules/ecs"
  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  cluster_name      = "app-cluster"
  service_sg_id      = module.ecs.ecs_service_sg_id
  execution_role_arn = module.ecs.ecs_execution_role_arn
  task_role_arn      = module.ecs.ecs_task_role_arn

  service_configs   = {
    service-a = {
      image         = "<aws_account_id>.dkr.ecr.<region>.amazonaws.com/service-a:latest"
      port          = 3000
      tg_arn        = module.alb.service_a_tg_arn
      container_cpu = 256
      container_mem = 512
    }
    service-b = {
      image         = "<aws_account_id>.dkr.ecr.<region>.amazonaws.com/service-b:latest"
      port          = 3001
      tg_arn        = module.alb.service_b_tg_arn
      container_cpu = 256
      container_mem = 512
    }
    service-c = {
      image         = "<aws_account_id>.dkr.ecr.<region>.amazonaws.com/service-c:latest"
      port          = 3002
      tg_arn        = module.alb.service_c_tg_arn
      container_cpu = 256
      container_mem = 512
    }
    service-d = {
      image         = "<aws_account_id>.dkr.ecr.<region>.amazonaws.com/service-d:latest"
      port          = 3003
      tg_arn        = module.alb.service_d_tg_arn
      container_cpu = 256
      container_mem = 512
    }
    service-e = {
      image         = "<aws_account_id>.dkr.ecr.<region>.amazonaws.com/service-e:latest"
      port          = 3004
      tg_arn        = module.alb.service_e_tg_arn
      container_cpu = 256
      container_mem = 512
    }
  }
}

module "codebuild" {
  source              = "./modules/codebuild"
  repo_names          = ["service-a", "service-b", "service-c", "service-d", "service-e"]
  artifact_bucket_arn = module.s3.bucket_arn

  buildspec_paths = {
    "service-a" = "${path.root}/buildspecs/service-a_buildspec.yml"
    "service-b" = "${path.root}/buildspecs/service-b_buildspec.yml"
    "service-c" = "${path.root}/buildspecs/service-c_buildspec.yml"
    "service-d" = "${path.root}/buildspecs/service-d_buildspec.yml"
    "service-e" = "${path.root}/buildspecs/service-e_buildspec.yml"
  }
}

module "codepipeline" {
  source                 = "./modules/codepipeline"
  repo_names             = module.codebuild.repo_names
  artifact_bucket_name   = module.s3.bucket_name
  github_token           = var.github_token
  github_owner           = var.github_owner
  ecs_cluster_name       = module.ecs.ecs_cluster_id
  namespace_id           = var.namespace_id
}
