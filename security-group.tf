# =========| SECURITY GROUPS |=========
resource "aws_security_group" "alb-security-group" {
  name        = "ALB Security Group"
  description = "Enable HTTP/HTTPS access on Port 80/443"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "HTTP Access"
    from_port        = var.http-port
    to_port          = var.http-port
    protocol         = "tcp"
    cidr_blocks      = [var.default-cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.default-cidr]
  }

  tags   = {
    Name = "ALB Security Group"
  }
}
# ================================