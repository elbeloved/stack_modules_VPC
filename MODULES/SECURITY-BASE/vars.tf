variable "project" {
  description = "security group name"
  type        = string
  default     = "CliXX"
}

variable "access_ports" {
  type    = list(number)
  default = [ ] 
}

variable "access_ports_priv" {
  type    = list(number)
  default = [80, 22, 3306, 2049, 8000] 
}

variable "required_tags"{
description="Tags required to be specified on all resources"
type=object({})
}

variable "vpc_id" {
  type    = string
  default = ""
}
