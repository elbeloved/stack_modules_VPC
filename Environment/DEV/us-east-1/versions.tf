# terraform {
#   required_version = ">= 0.12"
# } 

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.43.0"
    }
  }

  required_version = ">= 0.12"
}