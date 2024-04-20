variable "project" {
    default = "CliXX"
}

variable "cpu" {}

variable "host_port" {}

variable "container_port" {}

variable "memory_container" {}

variable "memory" {}

variable "instance_role" {}

variable "target_group" {
    type = string
}

variable "instance_type" {}

variable "instance_count" {}

#variable "path" {}

variable "ECS-Components" {
  type = map(string)
}

variable "repo_name" {}

variable "image_tag" {}

variable "autoscaling" {
    type = string
}
