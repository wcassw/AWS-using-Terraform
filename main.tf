module "network" {
  source = "./modules/network"

  aws_region = var.aws_region
  az1        = var.az1
  az2        = var.az2

  vpc_cidr               = var.vpc_cidr
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr

  private1_az1_cidr = var.private1_az1_cidr
  private2_az1_cidr = var.private2_az1_cidr
  private1_az2_cidr = var.private1_az2_cidr
  private2_az2_cidr = var.private2_az2_cidr
}

module "compute" {
  source = "./modules/compute"

  vpc_id = module.network.vpc_id

  # private subnets for ASG:
  private_subnet_ids_for_asg = [
    module.network.private_subnet_az1_1_id,
    module.network.private_subnet_az2_1_id
  ]

  # Public subnets for ALB:
  public_subnet_ids = [
    module.network.public_subnet_1_id,
    module.network.public_subnet_2_id
  ]

  app_ami_id      = var.app_ami_id
  instance_type   = var.instance_type
  asg_min         = var.asg_min
  asg_desired     = var.asg_desired
  asg_max         = var.asg_max
  db_secret_arn   = module.database.db_secret_arn

  acm_certificate_arn  = module.acm.acm_certificate_arn
}

module "database" {
  source = "./modules/database"

  vpc_id = module.network.vpc_id

  # Private subnets for RDS subnets:
  db_subnet_ids = [
    module.network.private_subnet_az1_2_id,
    module.network.private_subnet_az2_2_id
  ]

  app_sg_id    = module.compute.app_sg_id
  db_name      = var.db_name
  db_identifier = var.db_identifier
  instance_cls = var.db_instance_class
}

# Pass RDS endpoint down to user data through the compute module update:
resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/app/db/endpoint"
  type  = "String"
  value = module.database.db_endpoint
}

module "route53" {
  source = "./modules/route53"

  hosted_zone_id = var.route53_hosted_zone_id
  record_name    = var.app_domain_name

  alb_dns_name = module.compute.alb_dns_name
  alb_zone_id  = module.compute.alb_zone_id
}

module "monitoring" {
  source = "./modules/monitoring"

  asg_name                = module.compute.asg_name
  target_cpu_utilization  = var.target_cpu_utilization
  sns_topic_arn          = module.sns_notifications.sns_topic_arn
  alb_arn_suffix         = module.compute.alb_arn_suffix
  db_identifier          = module.database.db_identifier
}

module "sns_notifications" {
  source = "./modules/sns_notifications"

  sns_topic_name     = "asg-alerts-topic"
  notification_email = var.notification_email
  asg_name           = module.compute.asg_name
}

module "acm" {
  source         = "./modules/acm"
  domain_name    = var.app_domain_name
  hosted_zone_id = var.route53_hosted_zone_id
}
