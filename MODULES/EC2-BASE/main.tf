locals {
  ServerPrefix = ""
}

resource "aws_instance" "stack-bastion" {
  ami                     = var.ami_id
  instance_type           = var.EC2_Components["instance_type"]
  vpc_security_group_ids  = var.security_group_id
  key_name                = var.PATH_TO_PUBLIC_KEY
  subnet_id               = flatten(var.public_subnet)[0]

 tags = merge({Name  = "${local.ServerPrefix != "" ? local.ServerPrefix : "CliXX_Bastion_Server"}"}, var.required_tags)

}

resource "aws_instance" "stack-bastion_1b" {
  ami                     = var.ami_id
  instance_type           = var.EC2_Components["instance_type"]
  vpc_security_group_ids  = var.security_group_id
  key_name                = var.PATH_TO_PUBLIC_KEY
  subnet_id               = flatten(var.public_subnet_1b)[0]

  tags = merge({Name  = "${local.ServerPrefix != "" ? local.ServerPrefix : "CliXX_Bastion_Server_1b"}"}, var.required_tags)

}