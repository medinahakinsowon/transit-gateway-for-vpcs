




resource "aws_instance" "ec2_vpc1" {
  ami                         = "ami-0eb260c4d5475b901" # Replace with a valid AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc1_subnet1.id
  key_name                    = "medinatcodemed"
  vpc_security_group_ids      = ["sg-000473178f362b71c"]
  associate_public_ip_address = true

  tags = {
    Name = "EC2-VPC1"
  }

  depends_on = [aws_security_group.allow_all]
}

resource "aws_instance" "ec2_vpc2" {
  ami                         = "ami-0eb260c4d5475b901" # Replace with a valid AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc2_subnet1.id
  key_name                    = "medinatcodemed"
  vpc_security_group_ids      = ["sg-0c4ddb65e1c97a2da"]
  associate_public_ip_address = true

  tags = {
    Name = "EC2-VPC2"
  }

  depends_on = [aws_security_group.vpc2_allow_all]
}

resource "aws_instance" "ec2_vpc3" {
  ami                         = "ami-0eb260c4d5475b901" # Replace with a valid AMI ID
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.vpc3_subnet1.id
  key_name                    = "medinatcodemed"
  vpc_security_group_ids      = ["sg-0612942cec437f9d2"]
  associate_public_ip_address = true

  tags = {
    Name = "EC2-VPC3"
  }

  depends_on = [aws_security_group.vpc3_allow_all]

}





