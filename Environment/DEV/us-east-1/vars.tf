variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}

variable "OwnerEmail" {
  default = "ayanfeafelumo@gmail.com"
}

variable "Environment" {
  default = "dev"
}

variable "System" {
  default = "Retail Reporting"
}

variable "subsystem" {
  default = "CliXX"
}

variable "availability_zone" {
  default = "us-east-1c"
}

variable "subnets_cidrs" {
  type = list(string)
  default = [
    "172.31.80.0/20"
  ]
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "my_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "my_key.pub"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-stack-1.0"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "stack_controls" {
  type = map(string)
  default = {
    ec2_create = "Y"
    rds_create = "Y"
    sg_create  = "Y"
    asg_create = "Y"
    efs_create = "Y"
    vpc_create = "Y"
  }
}

variable "EC2_Components" {
  type = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.micro"
  }
}

variable "ASG_Components" {
  type = map(string)
  default = {
    max_size                  = 4
    min_size                  = 2
    desired_capacity          = 2
    health_check_grace_period = 30
    health_check_type         = "EC2"
  }
}

variable "LTG_Components" {
  type = map(string)
  default = {
    port                = 80
    protocol            = "HTTP"
    matcher             = 200
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

variable "Backup" {
  default = "yes"
}

variable "project" {
  default = "Clixx"
}

variable "required_tags"{
  type= map(string)
  default = {}
}

variable "db_group_subnet_ids" {
  description = "db_group_subnet_ids list"
  type        = list(string)
  default     = []
}

variable "instance_class" {
  description = "instance_class"
  type        = string
  default     = "db.t2.micro"
}

variable "skip_final_snapshot" {
  description = "skip_final_snapshot"
  type        = bool
  default     = true
}

variable "most_recent" {
  description = "most recent snapshot"
  type        = bool
  default     = true
}

variable "snapshot_identifier" {
  description = "db snapshot name"
  type        = string
  default     = "arn:aws:rds:us-east-1:577701061234:snapshot:wordpressdbclixx-ecs-snapshot"
}

variable "access_ports" {
  type    = list(number)
  default = [80, 22, 3306, 2049] # 22 -> ssh, 80 -> http, 3306 -> Aurora/MySQL, 2049 -> EFS mount
}

variable "access_ports_priv" {
  type    = list(number)
  default = [80, 22, 3306, 2049] 
}

variable "block_device_config" {
  type    = list(object({
    device_name  = string
    volume_size  = number
  }))
  default = [
  {
    device_name = "/dev/sdf"
    volume_size = 8
  },
  {
    device_name = "/dev/sdg"
    volume_size = 8
  },
  {
    device_name = "/dev/sdh"
    volume_size = 8
  },
  {
    device_name = "/dev/sdi"
    volume_size = 8
  },
  {
    device_name = "/dev/sdj"
    volume_size = 8
  }
  ]
}

variable "subnet_availability_zone" {
    default     = "us-east-1a"
}

variable "subnet_availability_zone_1b" {
    default     = "us-east-1b"
}
