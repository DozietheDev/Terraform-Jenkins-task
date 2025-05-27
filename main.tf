module "vpc" {
  source             = "./modules/vpc"
  cidr_block         = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "security_group" {
  source       = "./modules/security_group"
  vpc_id       = module.vpc.vpc_id
  allowed_cidr = var.allowed_cidr
}

module "iam" {
  source = "./modules/iam"
}

module "ecs" {
  source                = "./modules/ecs"
  cluster_name          = var.cluster_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_subnet_ids    = module.vpc.private_subnet_ids
  security_group_id     = module.security_group.security_group_id
  ecs_task_family       = var.ecs_task_family
  ecs_service_name      = var.ecs_service_name
  container_image       = var.container_image
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
}
