aws_region         = "ap-southeast-2"
vpc_cidr           = "172.18.0.0/16"
vpc_name           = "March-Vpc"
key_name           = "account2KP"
azs                = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
public_cidr_block  = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24", "172.18.4.0/24", "172.18.5.0/24"]
private_cidr_block = ["172.18.10.0/24", "172.18.20.0/24", "172.18.30.0/24", "172.18.40.0/24", "172.18.50.0/24"]
environment        = "Prod"
