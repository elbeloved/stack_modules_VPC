locals {
  ServerPrefix = ""
 
}

resource "aws_autoscaling_group" "scale" {
  name                      = "${var.project}-ASG"
  max_size                  = var.ASG_Components["max_size"]
  min_size                  = var.ASG_Components["min_size"]
  desired_capacity          = var.ASG_Components["desired_capacity"]
  health_check_grace_period = var.ASG_Components["health_check_grace_period"]
  health_check_type         = var.ASG_Components["health_check_type"]
  vpc_zone_identifier       = flatten(["${var.private_subnet}", "${var.private_subnet_1b}"])

  launch_template {
    id                      = aws_launch_template.takeoff.id  
    version                 = aws_launch_template.takeoff.latest_version
  }       

  tag {
    key                  = "Name"
    value                = "${var.project}-ASG-tags"
    propagate_at_launch  = true
  }

  target_group_arns      = [aws_lb_target_group.balance.arn]
}

resource "aws_lb" "balance" {
  name                   = "${var.project}-ALB"
  internal               = false
  load_balancer_type     = "application"
  security_groups        = var.security_group_id
  subnets                = flatten(["${var.public_subnet}", "${var.public_subnet_1b}"])
}

resource "aws_lb_target_group" "balance" {
  name                   = "${var.project}-LTG"
  port                   = var.LTG_Components["port"]
  protocol               = var.LTG_Components["protocol"]
  vpc_id                 = var.vpc_id

  health_check {
    matcher              = var.LTG_Components["matcher"]
    path                 = var.LTG_Components["path"]
    interval             = var.LTG_Components["interval"]
    timeout              = var.LTG_Components["timeout"]
    healthy_threshold    = var.LTG_Components["healthy_threshold"]
    unhealthy_threshold  = var.LTG_Components["unhealthy_threshold"]
  } 
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn      = aws_lb.balance.arn
  port                   = var.LTG_Components["port"]
  protocol               = var.LTG_Components["protocol"]
  default_action {
    type                 = "forward"
    target_group_arn     = aws_lb_target_group.balance.arn
  }     
}

resource "aws_launch_template" "takeoff" {
  name                   = "${var.project}-LT"
  image_id               = var.ami_id
  instance_type          = var.EC2_Components["instance_type"]
  user_data              = base64encode(var.user_data_filepath)

  vpc_security_group_ids = var.security_group_priv
  
  #create multiple EBS block
  dynamic "block_device_mappings" {
    for_each             = var.block_device_config

    content {
      device_name        = block_device_mappings.value.device_name  

    ebs {
      volume_size        = block_device_mappings.value.volume_size
      }
    }
  }  

  lifecycle {
     create_before_destroy = true
  }

  tags    = merge({Name  = "${local.ServerPrefix != "" ? local.ServerPrefix : "AWS_Launch_Temp"}"}, var.required_tags)

  }


data "aws_route53_zone" "clixx" {
  name    = var.hosted_zone
}

resource "aws_route53_record" "clixx" {
  zone_id = data.aws_route53_zone.clixx.zone_id
  name    = "hewitech.click"
  type    = "A"
  ttl     = "300"
  records = [module.vpc-us-east-1.address]
  latency_routing_policy {
    region = "us-east-1"
  }
}

 
