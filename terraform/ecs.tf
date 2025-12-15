resource "aws_ecs_cluster" "this" {
  name = "strapi-backend-cluster"
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-backend-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024

  execution_role_arn = var.existing_execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "strapi-backend"
      image = "${var.ecr_repo}:${var.image_tag}"

      portMappings = [
        { containerPort = 1337 }
      ]

      essential = true

      environment = [
        { name = "NODE_ENV", value = "production" },
        { name = "HOST", value = "0.0.0.0" },
        { name = "PORT", value = "1337" }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/strapi-backend"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "strapi" {
  name            = "strapi-backend-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets = [
      "subnet-019f80fcdf181c8d7",
      "subnet-0fa63b900995738f6"
    ]

    security_groups  = ["sg-009961e820fd3b943"]
    assign_public_ip = true
  }
}
