# =========| LOAD BALANCER |=========

resource "aws_lb" "demo" {
  name               = "terraform-asg-demo"
  load_balancer_type = "application" # type = ALB
  subnets            = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
  security_groups    = [aws_security_group.alb-security-group.id]
}

# ===================================



# =========| LISTENERS |=========

resource "aws_alb_listener" "http" {
  load_balancer_arn  = aws_lb.demo.arn
  port               = var.http-port
  protocol           = "HTTP"

  # Default return empty page with code 404
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

# =============================

# =========| LISTENER RULES |=========

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}

# ====================================