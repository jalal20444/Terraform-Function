resource "aws_security_group" "allow_tls" {
  name        = "${var.vpc_name}-allow-all"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.ingress_value
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name        = "${name.vpc_name}-allow-all"
    owner       = local.Owner
    costcenter  = local.costcenter
    TamDL       = local.TamDL
    environment = "${var.environment}"
  }
}
