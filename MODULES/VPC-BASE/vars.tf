# -------------------------------------------
# VPC Variables
# -------------------------------------------

variable "cidr" {
    description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
    type        = string
    default     = "10.0.0.0/16"
}

variable "cidr_private_subnet" {
    description = "CIDR block for private subnets"
    type        = list(string)
    default     = ["10.0.0.0/24", "10.0.8.0/22", "10.0.16.0/24", "10.0.18.0/26", "10.0.20.0/26"]
}

variable "cidr_private_subnet_1b" {
    description = "CIDR block for private subnets"
    type        = list(string)
    default     = ["10.0.1.0/24", "10.0.12.0/22", "10.0.17.0/24", "10.0.19.0/26", "10.0.21.0/26"]
}

variable "cidr_public_subnet" {
    description = "CIDR block for public subnets"
    default     = "10.0.2.0/23"
}

variable "cidr_public_subnet_1b" {
    description = "CIDR block for public subnets"
    default     = "10.0.4.0/23"
}

variable "instance_tenancy" {
    description = "A tenancy option for instances launched into the VPC"
    type        = string
    default     = "default"
}

variable "enable_dns_hostnames" {
    description = "Should be true to enable DNS hostnames in the VPC"
    type        = bool
    default     = true
}

variable "enable_dns_support" {
    description = "Should be true to enable DNS support in the VPC"
    type        = bool
    default     = true
}

variable "required_tags" {
    description = "Tags required to be specified on all resources"
    type        = object({})
}

variable "subnet_availability_zone" {}

variable "subnet_availability_zone_1b" {}

