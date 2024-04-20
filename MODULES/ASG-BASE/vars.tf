variable "ami_id"{}

variable "ECS-ami" {
  default = "ami-021fe45d6043e82c8"
}

variable "env" {}

variable "project" {
  default = "Clixx"
}

variable "stack_controls" {
  type = map(string)
  default = {}
}

variable "EC2_Components" {
  type = map(string)
  default = {}
}

variable "ASG_Components" {
  type = map(string)
  default = {}
}

variable "LTG_Components" {
  type = map(string)
  default = {}
}

variable "required_tags"{
  description="Tags required to be specified on all resources"
  type=object({})
}

variable "block_device_config" {
  type    = list(object({
    device_name  = string
    volume_size  = number
  }))
  default = [
  {
    device_name = ""
    volume_size = null
  },
  {
    device_name = ""
    volume_size = null
  },
  {
    device_name = ""
    volume_size = null
  },
  {
    device_name = ""
    volume_size = null
  },
  {
    device_name = ""
    volume_size = null
  }
  ]
}

variable "security_group_id" {
  type    = list(string)   
  default = [ ]
}

variable "security_group_priv" {
  type    = list(string)   
  default = [ ]
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "user_data_filepath" {
  type    = string
  default = ""
}

variable "private_subnet" {
    # type = list(string)
    # default = [ ]
}

variable "private_subnet_1b" {
    # type = list(string)
    # default = [ ]
}

variable "public_subnet" {
  default = ""
}

variable "public_subnet_1b" {
  default = ""
}

# variable "instance_profile" {}

variable "path" {}

variable "instance_role" {}

variable "ECS-Components" {
  type = map(string)
}
