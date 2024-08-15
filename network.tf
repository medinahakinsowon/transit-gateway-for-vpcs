

resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr_blocks["vpc1"]
}

resource "aws_vpc" "vpc2" {
  cidr_block = var.vpc_cidr_blocks["vpc2"]
}

resource "aws_vpc" "vpc3" {
  cidr_block = var.vpc_cidr_blocks["vpc3"]
}

resource "aws_subnet" "vpc1_subnet1" {
  vpc_id     = aws_vpc.vpc1.id
  cidr_block = var.public_subnet_cidrs["vpc1_subnet1"]
}

resource "aws_subnet" "vpc2_subnet1" {
  vpc_id     = aws_vpc.vpc2.id
  cidr_block = var.public_subnet_cidrs["vpc2_subnet1"]
}

resource "aws_subnet" "vpc3_subnet1" {
  vpc_id     = aws_vpc.vpc3.id
  cidr_block = var.public_subnet_cidrs["vpc3_subnet1"]
}



resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_internet_gateway" "vpc2_igw" {
  vpc_id = aws_vpc.vpc2.id
}

resource "aws_internet_gateway" "vpc3_igw" {
  vpc_id = aws_vpc.vpc3.id
}





resource "aws_route_table" "vpc1_rt" {
  vpc_id = aws_vpc.vpc1.id
}

resource "aws_route_table" "vpc2_rt" {
  vpc_id = aws_vpc.vpc2.id
}

resource "aws_route_table" "vpc3_rt" {
  vpc_id = aws_vpc.vpc3.id
}




resource "aws_route_table_association" "vpc1_rta" {
  subnet_id      = aws_subnet.vpc1_subnet1.id
  route_table_id = aws_route_table.vpc1_rt.id
}

resource "aws_route_table_association" "vpc2_rta" {
  subnet_id      = aws_subnet.vpc2_subnet1.id
  route_table_id = aws_route_table.vpc2_rt.id
}

resource "aws_route_table_association" "vpc3_rta" {
  subnet_id      = aws_subnet.vpc3_subnet1.id
  route_table_id = aws_route_table.vpc3_rt.id
}



resource "aws_route" "vpc1_igw_route" {
  route_table_id         = aws_route_table.vpc1_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc1_igw.id
}

resource "aws_route" "vpc2_igw_route" {
  route_table_id         = aws_route_table.vpc2_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc2_igw.id
}

resource "aws_route" "vpc3_igw_route" {
  route_table_id         = aws_route_table.vpc3_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc3_igw.id
}



resource "aws_ec2_transit_gateway" "main" {
  description                     = "Transit Gateway"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
}



resource "aws_ec2_transit_gateway_vpc_attachment" "vpc1_attachment" {
  subnet_ids         = [aws_subnet.vpc1_subnet1.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.vpc1.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc2_attachment" {
  subnet_ids         = [aws_subnet.vpc2_subnet1.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.vpc2.id
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpc3_attachment" {
  subnet_ids         = [aws_subnet.vpc3_subnet1.id]
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.vpc3.id
}


resource "aws_ec2_transit_gateway_route" "vpc1_to_vpc2" {
  destination_cidr_block         = var.vpc_cidr_blocks["vpc2"]
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment.id
}

/*
resource "aws_ec2_transit_gateway_route" "vpc1_to_vpc3" {
  destination_cidr_block         = var.vpc_cidr_blocks["vpc3"]
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc1_attachment.id
}
*/

resource "aws_ec2_transit_gateway_route" "vpc2_to_vpc1" {
  destination_cidr_block         = var.vpc_cidr_blocks["vpc1"]
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment.id
}

resource "aws_ec2_transit_gateway_route" "vpc2_to_vpc3" {
  destination_cidr_block         = var.vpc_cidr_blocks["vpc3"]
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc2_attachment.id
}

/*
resource "aws_ec2_transit_gateway_route" "vpc3_to_vpc1" {
  destination_cidr_block         = var.vpc_cidr_blocks["vpc1"]
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc3_attachment.id
}
*/

/*
resource "aws_ec2_transit_gateway_route" "vpc3_to_vpc2" {
  destination_cidr_block         = var.vpc_cidr_blocks["vpc2"]
  transit_gateway_route_table_id = aws_ec2_transit_gateway.main.association_default_route_table_id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.vpc3_attachment.id
}
*/






resource "aws_security_group" "allow_all" {
  vpc_id = aws_vpc.vpc1.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }

  #to have ssh connection from all the instances

   ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["102.88.70.152/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["102.88.70.152/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }


  ingress {
    description = "ICMP (Ping) from anywhere"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_1"
  }
}


resource "aws_security_group" "vpc2_allow_all" {
  vpc_id = aws_vpc.vpc2.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["102.88.70.152/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["102.88.70.152/32"]
  }
  
    ingress {
    description = "ICMP (Ping) from anywhere"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr_blocks["vpc1"], var.vpc_cidr_blocks["vpc2"], var.vpc_cidr_blocks["vpc3"]]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all_2"
  }
}
