output "dns_name" {
  description = "The connection endpoint in address:port format."
  value       = aws_efs_file_system.efs.dns_name

  depends_on  = [var.vpc_id]
}

output "efs_mount_target" {
  value      = aws_efs_mount_target.mount[*].id

  depends_on = [var.security_group_priv]
}

output "efs_mount_target_1b" {
  value      = aws_efs_mount_target.mount_1b[*].id

  depends_on = [var.security_group_priv]
}