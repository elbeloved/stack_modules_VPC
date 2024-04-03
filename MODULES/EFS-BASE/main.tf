locals {
  ServerPrefix = ""
}

resource "aws_efs_file_system" "efs" {
    creation_token = "${var.project}-efs"
    tags = merge({Name  = "${local.ServerPrefix != "" ? local.ServerPrefix : "CliXX_File_System"}"}, var.required_tags)
}

resource "aws_efs_mount_target" "mount" {
    file_system_id   =  aws_efs_file_system.efs.id
    subnet_id        =  var.private_subnet[0]  
    security_groups  =  var.security_group_priv
}

resource "aws_efs_mount_target" "mount_1b" {
    file_system_id  = aws_efs_file_system.efs.id
    subnet_id       = var.private_subnet_1b[0]
    security_groups = var.security_group_priv
}