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
  service_sg_id     = aws_security_group.ecs_service_sg.id
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
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
