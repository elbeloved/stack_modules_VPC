output "endpoint" {
  description = "The connection endpoint in address:port format."
  value       = aws_db_instance.stack.endpoint
}

output "id" {
  description = " The RDS instance ID.."
  value       = aws_db_instance.stack.id
}

