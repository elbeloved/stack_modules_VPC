output "dns_name" {
  description = "The load balancer's dns."
  value       = aws_lb.balance.dns_name
}

output "scaling" {
  value       = aws_autoscaling_group.scale.arn
}

output "target_group" {
  value        = aws_lb_target_group.balance.arn
}

output "autoscaling" {
  value        = aws_autoscaling_group.scale.arn
}
