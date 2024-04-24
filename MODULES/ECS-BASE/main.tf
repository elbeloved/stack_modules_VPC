resource "aws_ecs_cluster" "stack" {
    name = "${var.project}-cluster"
}

resource "aws_ecs_service" "service" {
    depends_on = [var.lb_listener]
    name            = "${var.project}-service"
    cluster         = aws_ecs_cluster.stack.name
    launch_type     = var.instance_type
    task_definition = aws_ecs_task_definition.stack.arn
    desired_count   = var.instance_count

    load_balancer {
      container_name   = "${var.project}-container"
      container_port   = var.container_port
      target_group_arn = "${var.target_group}"             
    }
}

resource "aws_ecs_task_definition" "stack" {
    family                   = "${var.project}-td"
    requires_compatibilities = [var.instance_type]
    execution_role_arn       = data.aws_iam_role.stack.arn
    cpu                      = var.cpu
    memory                   = var.memory
    

    container_definitions = jsonencode([
        {
            name          = "${var.project}-container"
            image         = "${data.aws_ecr_image.stack.image_uri}"
            memory        = var.memory_container
            essential     = true
            portMappings  = [
                {
                    containerPort = var.container_port
                    hostPort      = var.host_port
                }
            ]
        }
    ])
}
#####################

resource "aws_ecs_capacity_provider" "main" {
  name = "${var.project}-ecs-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = "${var.autoscaling}" 
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = var.ECS-Components["max_scaling"]
      minimum_scaling_step_size = var.ECS-Components["min_scaling"]
      status                    = "ENABLED"
      target_capacity           = var.ECS-Components["target_cap"]
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = aws_ecs_cluster.stack.name
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    base              = var.ECS-Components["base"]
    weight            = var.ECS-Components["weight"]
  }
}

# resource "aws_iam_instance_profile" "ecs_node" {
#   name_prefix = "${var.project}-node-profile"
#   path        = var.path
#   role        = data.aws_iam_role.stack.id
# }