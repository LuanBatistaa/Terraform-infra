data "aws_ami" "debian12" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_launch_template" "debian_template" {
  name_prefix   = "${var.projeto}-${var.candidato}-ec2"
  image_id      = data.aws_ami.debian12.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ec2_key_pair.key_name
  user_data     = base64encode(var.user_data)
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.main_sg.id, aws_security_group.web_sg.id]
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-launch-template"
  }
}

resource "aws_autoscaling_group" "main_as_group" {
  name                      = "${var.projeto}-${var.candidato}-asg"
  vpc_zone_identifier       = [aws_subnet.main_subnet.id, aws_subnet.secondary_subnet.id]
  desired_capacity          = 2
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  capacity_rebalance        = true
  launch_template {
    id      = aws_launch_template.debian_template.id
    version = aws_launch_template.debian_template.latest_version
  }

  target_group_arns = [
    aws_lb_target_group.main_tg.arn
  ]

  depends_on = [aws_launch_template.debian_template]

}