resource "aws_lb" "sample_alb" {
  name               = "sample-alb"
  load_balancer_type = "application"

  security_groups = [aws_security_group.allow_access_alb.id]
  subnets         = [
    data.aws_subnet.public_a.id,
    data.aws_subnet.public_c.id,
    data.aws_subnet.public_d.id
  ]

  enable_deletion_protection = false

  tags = {
    terraform = true
  }
}

resource "aws_lb_target_group" "sample_alb_target_group" {
  name = "sample-alb-target-group"

  port     = "80"
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  tags = {
    terraform = true
  }
}

resource "aws_lb_listener" "sample_alb_listener" {
  load_balancer_arn = aws_lb.sample_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sample_alb_target_group.arn
  }
}


resource "aws_security_group" "allow_access_alb" {
  name = "AllowAccessALB"

  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  tags = {
    terraform = true
  }
}
