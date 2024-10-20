resource "aws_lb" "main_lb" {
  name                             = "${var.projeto}-${var.candidato}-lb"
  internal                         = false
  enable_cross_zone_load_balancing = true
  subnets                          = [aws_subnet.main_subnet.id, aws_subnet.secondary_subnet.id]
  enable_http2                     = true
  load_balancer_type               = "application"
  security_groups                  = [aws_security_group.main_sg.id, aws_security_group.web_sg.id]
  tags = {
    Name = "${var.projeto}-${var.candidato}-lb"
  }
}

resource "aws_lb_target_group" "main_tg" {
  connection_termination             = false
  lambda_multi_value_headers_enabled = false
  load_balancing_algorithm_type      = "round_robin"
  name                               = "${var.projeto}-${var.candidato}-tg"
  port                               = 80
  protocol                           = "HTTP"
  protocol_version                   = "HTTP1"
  target_type                        = "instance"
  vpc_id                             = aws_vpc.main_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 5
  }

  stickiness {
    cookie_duration = 86400
    enabled         = false
    type            = "lb_cookie"
  }
  tags = {
    Name = "${var.projeto}-${var.candidato}-tg"
  }
}

resource "aws_lb_listener" "listener-http" {
  load_balancer_arn = aws_lb.main_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main_tg.arn
  }
}
