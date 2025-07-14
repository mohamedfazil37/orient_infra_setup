resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "this" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "service_a" {
  name     = "service-a-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "service_b" {
  name     = "service-b-tg"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "service_c" {
  name     = "service-c-tg"
  port     = 3002
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "service_d" {
  name     = "service-d-tg"
  port     = 3003
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "service_e" {
  name     = "service-e-tg"
  port     = 3004
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Default response"
      status_code  = "200"
    }
  }
}

resource "aws_lb_listener_rule" "service_a" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 10
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_a.arn
  }
  condition {
    path_pattern { values = ["/service-a/*"] }
  }
}

resource "aws_lb_listener_rule" "service_b" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 20
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_b.arn
  }
  condition {
    path_pattern { values = ["/service-b/*"] }
  }
}

resource "aws_lb_listener_rule" "service_c" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 30
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_c.arn
  }
  condition {
    path_pattern { values = ["/service-c/*"] }
  }
}

resource "aws_lb_listener_rule" "service_d" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 40
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_d.arn
  }
  condition {
    path_pattern { values = ["/service-d/*"] }
  }
}

resource "aws_lb_listener_rule" "service_e" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 50
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_e.arn
  }
  condition {
    path_pattern { values = ["/service-e/*"] }
  }
}