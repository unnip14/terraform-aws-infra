
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-unni"
    key            = "vpc/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_instance" "web" {
  ami           = "ami-020cba7c55df1f615" # Update with latest Amazon Linux AMI
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.main_subnet.id
  key_name      = "terra-test-unni"

  tags = {
    Name = "Terraform-EC2"
  }
}
