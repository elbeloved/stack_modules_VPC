data "aws_iam_role" "stack" {
    name = var.instance_role
}

data "aws_ecr_image" "stack" {
    repository_name = var.repo_name
    image_tag       = var.image_tag
}

