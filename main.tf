#This Terraform Code Deploys Basic VPC Infra.
provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket = "march2025workspace"
    key    = "function.tfstate"
    region = "ap-southeast-2"
  }
}

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.vpc_name}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TamDL       = local.TamDL
    environment = "${var.environment}"
  }
}

resource "aws_internet_gateway" "my-gw" {
  vpc_id = aws_vpc.default.id
  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_subnet" "Public-subnet" {
  #count             = 3
  count             = length(var.public_cidr_block)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.public_cidr_block, count.index + 1)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-Public-subnet-${count.index + 1}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TamDL       = local.TamDL
    environment = "${var.environment}"
  }
}

resource "aws_subnet" "Private-subnet" {
  #count             = 3
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(var.private_cidr_block, count.index + 1)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name        = "${var.vpc_name}-Private-subnet-${count.index + 1}"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TamDL       = local.TamDL
    environment = "${var.environment}"
  }
}

resource "aws_route_table" "Public-RT" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gw.id
  }

  tags = {
    Name        = "${var.vpc_name}-Public-RT"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TamDL       = local.TamDL
    environment = "${var.environment}"
  }
}

resource "aws_route_table" "Private-RT" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name        = "${var.vpc_name}-Private-RT"
    Owner       = local.Owner
    costcenter  = local.costcenter
    TamDL       = local.TamDL
    environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "Public-Association" {
  #count          = 3
  count          = length(var.public_cidr_block)
  subnet_id      = element(aws_subnet.Public-subnet.*.id, count.index)
  route_table_id = aws_route_table.Public-RT.id
}

resource "aws_route_table_association" "Private-Association" {
  #count          = 3
  count          = length(var.private_cidr_block)
  subnet_id      = element(aws_subnet.Private-subnet.*.id, count.index)
  route_table_id = aws_route_table.Private-RT.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.default.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# resource "aws_instance" "web-1" {
#     ami = "${data.aws_ami.my_ami.id}"
#     #ami = "ami-0d857ff0f5fc4e03b"
#     availability_zone = "us-east-1a"
#     instance_type = "t2.micro"
#     key_name = "LaptopKey"
#     subnet_id = "${aws_subnet.subnet1-public.id}"
#     vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]
#     associate_public_ip_address = true	
#     tags = {
#         Name = "Server-1"
#         Env = "Prod"
#         Owner = "sai"
# 	CostCenter = "ABCD"
#     }
#      user_data = <<- EOF
#      #!/bin/bash
#      	sudo apt-get update
#      	sudo apt-get install -y nginx
#      	echo "<h1>${var.env}-Server-1</h1>" | sudo tee /var/www/html/index.html
#      	sudo systemctl start nginx
#      	sudo systemctl enable nginx
#      EOF

# }



##output "ami_id" {
#  value = "${data.aws_ami.my_ami.id}"
#}
#!/bin/bash
# echo "Listing the files in the repo."
# ls -al
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Packer Now...!!"
# packer build -var=aws_access_key=AAAAAAAAAAAAAAAAAA -var=aws_secret_key=BBBBBBBBBBBBB packer.json
# echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++"
# echo "Running Terraform Now...!!"
# terraform init
# terraform apply --var-file terraform.tfvars -var="aws_access_key=AAAAAAAAAAAAAAAAAA" -var="aws_secret_key=BBBBBBBBBBBBB" --auto-approve
