variable "project" {}
  
variable "required_tags" {}

variable "security_group_priv" {
    type    = list(string)
    default = [ ]
}

variable "efs_mount_target" {
    default = 4
}

variable "scaling" {}

variable "vpc_id" {}

variable "private_subnet" {
    type = list(string)
    default = [ ]
}

variable "private_subnet_1b" {
    type = list(string)
    default = [ ]
}

