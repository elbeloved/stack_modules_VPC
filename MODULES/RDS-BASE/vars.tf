variable "project" {
  default     = "Clixx"
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
  default     = null
}

variable "snapshot_identifier" {
  description = "db snapshot name"
  type        = string
  default     = ""
}

variable "stack_controls" {
  type = map(string)
  default = {}
}

variable "required_tags"{
description="Tags required to be specified on all resources"
type=object({})
}

variable "private_subnet" {
    type = list(string)
    default = [ ]
}

variable "private_subnet_1b" {
    type = list(string)
    default = [ ]
}

variable "subnet_availability_zone" {
    type        = list(string)
    default     = ["us-east-1a"]
}

variable "security_group_priv" {
    type    = list(string)
    default = [ ]
}
