provider "aws" {
    region = "us-east-1"
}

#variables
variable vpc_cidr_blocks {}
variable subnet_cidr_blocks {}
variable avail_zone {}
variable env_prefix {}

#resources
resource "aws_vpc" "myapp-vpc" {
    cidr_block = var.vpc_cidr_blocks
    tags = {
        Name: "${var.env_prefix}-vpc"
    }

}

resource "aws_subnet" "myapp-subnet-1"{
    vpc_id = aws_vpc.myapp-vpc.id
    cidr_block = var.subnet_cidr_blocks
    availability_zone = var.avail_zone
    tags = {
        Name: "${var.env_prefix}-subnet-1"
    }
}

# resource "aws_route_table" "myapp-route-table" {
#     vpc_id = aws_vpc.myapp-vpc.id
#     route {
#         cidr_block = "0.0.0.0/0"
#         gateway_id = aws_internet_gateway.myapp-igw.id
#     }
#     tags = {
#         Name: "${var.env_prefix}-route-table"
#     }
# }

# resource "aws_route_table_association" "a-rtb-subnet" {
#     subnet_id = aws_subnet.myapp-subnet-1.id
#     route_table_id = aws_route_table.myapp-route-table.id
# }

resource "aws_internet_gateway" "myapp-igw" {
    vpc_id = aws_vpc.myapp-vpc.id
    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

resource "aws_default_route_table" "main-route-table" {
    default_route_table.id = aws_vpc.myapp-vpc.default_route_table_id
    route {
         cidr_block = "0.0.0.0/0"
         gateway_id = aws_internet_gateway.myapp-igw.id
     }
     tags = {
         Name: "${var.env_prefix}-main_rtb"
     }
}