
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.projeto}-${var.candidato}-vpc"
  }
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "${var.projeto}-${var.candidato}-subnet"
  }

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_subnet" "secondary_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "${var.projeto}-${var.candidato}-subnet-secondary"
  }

  depends_on = [aws_vpc.main_vpc]
}
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.projeto}-${var.candidato}-igw"
  }

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-route_table"
  }

  depends_on = [aws_vpc.main_vpc, aws_internet_gateway.main_igw]
}

resource "aws_route_table_association" "main_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id

  depends_on = [aws_subnet.main_subnet, aws_route_table.main_route_table]
}

resource "aws_route_table_association" "secondary_association" {
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.main_route_table.id

  depends_on = [aws_subnet.secondary_subnet, aws_route_table.main_route_table]
}

resource "aws_security_group" "main_sg" {
  name        = "${var.projeto}-${var.candidato}-sg"
  description = "Permitir SSH de um IP especifico e todo o trafego de saida"
  vpc_id      = aws_vpc.main_vpc.id

  # Regras de entrada
  ingress {
    description      = "Permitir SSH de um IP especifico"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["45.65.231.122/32"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Regras de saída
  egress {
    description      = "Permitir todo o trafego de saida"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-sg"
  }

  depends_on = [aws_vpc.main_vpc]
}

resource "aws_security_group" "web_sg" {
  name        = "${var.projeto}-${var.candidato}-web-sg"
  description = "Permitir acesso web de qualquer lugar e todo o trafego de saida"
  vpc_id      = aws_vpc.main_vpc.id

  # Regras de entraDA

  ingress {
    description      = "Acesso web de qualquer lugar"
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  # Regras de saída
  egress {
    description      = "Permitir todo o trafego de saida"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.projeto}-${var.candidato}-sg"
  }

  depends_on = [aws_vpc.main_vpc]
}