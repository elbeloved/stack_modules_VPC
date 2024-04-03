output "security_group_stack" {
  value = aws_security_group.stack.id
}

output "security_group_priv" {
  value = aws_security_group.stack-app.id
}
