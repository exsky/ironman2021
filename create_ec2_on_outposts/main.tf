terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_instance" "terraform_start_app_server" {
  ami           = "${var.ami_id}" # Ubuntu
  instance_type = "m5.large"
  subnet_id     = "${var.subnet_outposts_1}"

  tags = {
    Name = "${var.instance_name}"
  }
}

output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.terraform_start_app_server.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.terraform_start_app_server.public_ip
}

