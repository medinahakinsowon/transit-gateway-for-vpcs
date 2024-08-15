


variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_blocks" {
  description = "CIDR blocks for the VPCs"
  type        = map(string)
  default = {
    vpc1 = "10.0.0.0/16"
    vpc2 = "10.1.0.0/16"
    vpc3 = "10.2.0.0/16"
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = map(string)
  default = {
    vpc1_subnet1 = "10.0.1.0/24"
    vpc2_subnet1 = "10.1.1.0/24"
    vpc3_subnet1 = "10.2.1.0/24"
  }
}
