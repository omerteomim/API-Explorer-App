# Security group for the ALB
resource "aws_security_group" "alb_sg" {
  name_prefix = "${var.environment}-alb-sg-"
  vpc_id      = var.vpc_id

  # Allow HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS traffic from anywhere (optional)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-alb-security-group"
    Environment = var.environment
  }
}

# Security group rule to allow ALB to reach instances on port 5000
resource "aws_security_group_rule" "allow_alb_to_instances" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = var.security_group_id
}

# Application Load Balancer
resource "aws_lb" "main" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = "${var.environment}-alb"
    Environment = var.environment
  }
}

# Target Group for the instances
resource "aws_lb_target_group" "instances" {
  name     = "${var.environment}-instances-tg"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    path                = var.health_check_path
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
  }

  tags = {
    Name        = "${var.environment}-instances-target-group"
    Environment = var.environment
  }
}

# Attach existing instances to the target group
resource "aws_lb_target_group_attachment" "instances" {
  count            = length(var.instance_ids)
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = var.instance_ids[count.index]
  port             = 5000
}

# ALB Listener
resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}