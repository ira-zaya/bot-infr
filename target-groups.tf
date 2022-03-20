# # =========| TARGET GROUPS |=========

resource "aws_lb_target_group" "asg" {
  name     = "terraform-asg-demo"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  target_type = "ip"

  health_check {
    path                 = "/"
    protocol             = "HTTP"
    matcher              = "200"
    interval             = 15
    timeout              = 3
    healthy_threshold    = 2
    unhealthy_threshold  = 2
  }
}
# ==================================
