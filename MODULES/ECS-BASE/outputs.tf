# output "iam_instance_profile" {
#  value = aws_iam_instance_profile.ecs_node.arn
# }

output "ecs_cluster" {
  value = aws_ecs_cluster.stack.name
}