locals {
  ServerPrefix = ""
}

module "CORE-INFO" {
  source                 = "../../../MODULES/CORE-INFO"
  required_tags          = {
    Environment          = var.Environment,
    OwnerEmail           = var.OwnerEmail,
    System               = var.System,
    Backup               = var.Backup,
    Region               = var.Region
  }
}

module "VPC-BASE" {
  count                        = var.stack_controls["vpc_create"] == "Y" ? 1 : 0
  source                       = "../../../MODULES/VPC-BASE"
  required_tags                = module.CORE-INFO.all_resource_tags
  subnet_availability_zone     = var.subnet_availability_zone
  subnet_availability_zone_1b  = var.subnet_availability_zone_1b
}

module "SECURITY-BASE" {
  count                  = var.stack_controls["sg_create"] == "Y" ? 1 : 0
  source                 = "../../../MODULES/SECURITY-BASE"
  required_tags          = module.CORE-INFO.all_resource_tags
  access_ports           = var.access_ports
  vpc_id                 = module.VPC-BASE[0].stack_vpc_id
}

module "EC2-BASE" {
  count                  = var.stack_controls["ec2_create"] == "Y" ? 1 : 0
  source                 = "../../../MODULES/EC2-BASE"
  ami_id                 = data.aws_ami.stack_ami.id
  stack_controls         = var.stack_controls
  EC2_Components         = var.EC2_Components
  env                    = var.Environment
  project                = var.project
  security_group_id      = module.SECURITY-BASE[*].security_group_stack
  required_tags          = module.CORE-INFO.all_resource_tags
  public_subnet          = module.VPC-BASE[*].public_subnet
  public_subnet_1b       = module.VPC-BASE[*].public_subnet_1b
}

module "ASG-BASE" {
  count                  = var.stack_controls["asg_create"] == "Y" ? 1 : 0 
  source                 = "../../../MODULES/ASG-BASE"
  ami_id                 = data.aws_ami.stack_ami.id
  stack_controls         = var.stack_controls
  EC2_Components         = var.EC2_Components
  env                    = var.Environment
  ASG_Components         = var.ASG_Components
  project                = var.project
  LTG_Components         = var.LTG_Components
  security_group_id      = module.SECURITY-BASE[*].security_group_stack
  security_group_priv    = module.SECURITY-BASE[*].security_group_priv
  required_tags          = module.CORE-INFO.all_resource_tags
  vpc_id                 = module.VPC-BASE[0].stack_vpc_id
  public_subnet          = module.VPC-BASE[*].public_subnet
  public_subnet_1b       = module.VPC-BASE[*].public_subnet_1b
  private_subnet         = module.VPC-BASE[*].private_subnet
  private_subnet_1b      = module.VPC-BASE[*].private_subnet_1b
  block_device_config    = var.block_device_config
  user_data_filepath     = data.template_file.ECSbootstrap.rendered
  path                   = var.path
  instance_role          = var.instance_role
  ECS-Components         = var.ECS-Components
}

module "RDS-BASE" {
  count                  = var.stack_controls["rds_create"] == "Y" ? 1 : 0 
  source                 = "../../../MODULES/RDS-BASE"
  snapshot_identifier    = var.snapshot_identifier
  instance_class         = var.instance_class
  skip_final_snapshot    = var.skip_final_snapshot
  required_tags          = module.CORE-INFO.all_resource_tags
  project                = var.project
  private_subnet         = module.VPC-BASE[*].private_subnet[1]
  private_subnet_1b      = module.VPC-BASE[*].private_subnet_1b[1]
  security_group_priv    = module.SECURITY-BASE[*].security_group_priv
}

module "EFS-BASE" {
  count                  = var.stack_controls["efs_create"] == "Y" ? 1 : 0
  source                 = "../../../MODULES/EFS-BASE"
  project                = var.project
  security_group_priv    = module.SECURITY-BASE[*].security_group_priv
  required_tags          = module.CORE-INFO.all_resource_tags
  scaling                = module.ASG-BASE[*].scaling
  vpc_id                 = module.VPC-BASE[*].stack_vpc_id
  private_subnet         = module.VPC-BASE[*].private_subnet[0]
  private_subnet_1b      = module.VPC-BASE[*].private_subnet_1b[0]
}

module "ECS-BASE" {
   count                  = var.stack_controls["ecs_create"] == "Y" ? 1 : 0
   source                 = "../../../MODULES/ECS-BASE"
   cpu                    = var.cpu
   host_port              = var.host_port
   container_port         = var.container_port
   memory_container       = var.memory_container
   target_group           = module.ASG-BASE[0].target_group
   memory                 = var.memory
   instance_role          = var.instance_role
   instance_type          = var.instance_type
   instance_count         = var.instance_count
   repo_name              = var.repo_name
   image_tag              = var.image_tag
   ECS-Components         = var.ECS-Components
   autoscaling            = module.ASG-BASE[0].autoscaling
   lb_listener            = module.ASG-BASE.listener
}
