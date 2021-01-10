resource "aws_ecs_cluster" "sample" {
  name = "sample-alb-backend"
}


resource "aws_iam_role" "ecs_execution" {
  name = "ECSExecutionRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role = aws_iam_role.ecs_execution.name
  policy_arn = data.aws_iam_policy.ecs_execution.arn
}

data "aws_iam_policy" "ecs_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "sample_ecs" {
  name = "/ecs/sample-ecs-service"
  retention_in_days = 1
}

resource "aws_security_group" "allow_alb_access_ecs" {
  name = "AllowALBAccessECSService"

  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    self = true
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}
