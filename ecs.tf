
# =========| ECR |=========

resource "aws_ecr_repository" "ecr_repository" {
  name = local.repository_name
}


# =========| ECS |=========

resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}-${var.environment}-cluster"
}


resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-${var.environment}-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions = jsonencode([{
    name        = "first"
    image       = "581835478100.dkr.ecr.eu-west-2.amazonaws.com/hello-dev:v1"
    essential   = true
    cpu         = 256
    memory      = 512

    portMappings = [
      {
        containerPort = 80
        hostPort      = 80
      }
    ]
  }])
}

resource "aws_ecs_service" "main" {
  name            = "${var.app_name}-${var.environment}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.alb-security-group.id]
    subnets          = ["${aws_subnet.private-subnet[0].id}", "${aws_subnet.private-subnet[1].id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.asg.id
    container_name   = "first"
    container_port   = var.http-port
  }

  depends_on = [aws_alb_listener.http, aws_iam_role_policy.ecs_task_execution_role]
}

// ------------------------------------------------------------------------------------------------------------------------------