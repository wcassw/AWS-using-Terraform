resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "web-app-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = { Name = "web-app-igw" }
}

# Public subnet in AZ1
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-1" }
}

# Public subnet in AZ2
resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_az2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = { Name = "public-subnet-2" }
}

# Private subnets (two per AZ)
resource "aws_subnet" "private_az1_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private1_az1_cidr
  availability_zone = var.az1
  tags = { Name = "private-subnet-1" }
}

resource "aws_subnet" "private_az1_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private2_az1_cidr
  availability_zone = var.az1
  tags = { Name = "private-subnet-2" }
}

resource "aws_subnet" "private_az2_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private1_az2_cidr
  availability_zone = var.az2
  tags = { Name = "private-subnet-1" }
}

resource "aws_subnet" "private_az2_2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private2_az2_cidr
  availability_zone = var.az2
  tags = { Name = "private-subnet-2" }
}

# NAT per AZ for high availability
resource "aws_eip" "nat_az1" {
  domain = "vpc"
  tags   = { Name = "eip-nat-1" }
}
resource "aws_eip" "nat_az2" {
  domain = "vpc"
  tags   = { Name = "eip-nat-2" }
}

resource "aws_nat_gateway" "nat_az1" {
  allocation_id = aws_eip.nat_az1.id
  subnet_id     = aws_subnet.public_az1.id
  tags          = { Name = "nat-1" }
}

resource "aws_nat_gateway" "nat_az2" {
  allocation_id = aws_eip.nat_az2.id
  subnet_id     = aws_subnet.public_az2.id
  tags          = { Name = "nat-2" }
}

# Route tables
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route { 
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id 
    }
  tags = { Name = "rtb-public" }
}

resource "aws_route_table_association" "public_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public.id
}

# Private RTBs: send to respective NATs
resource "aws_route_table" "private_az1" {
  vpc_id = aws_vpc.vpc.id
  route { 
    cidr_block = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.nat_az1.id 
}
  tags = { Name = "rtb-private-1" }
}
resource "aws_route_table" "private_az2" {
  vpc_id = aws_vpc.vpc.id
  route { 
    cidr_block = "0.0.0.0/0" 
    nat_gateway_id = aws_nat_gateway.nat_az2.id 
}
  tags = { Name = "rtb-private-2" }
}

# Associate all private subnets in AZ1 with private_az1 RTB
resource "aws_route_table_association" "private_az1_1" {
  subnet_id      = aws_subnet.private_az1_1.id
  route_table_id = aws_route_table.private_az1.id
}
resource "aws_route_table_association" "private_az1_2" {
  subnet_id      = aws_subnet.private_az1_2.id
  route_table_id = aws_route_table.private_az1.id
}

# Associate all private subnets in AZ2 with private_az2 RTB
resource "aws_route_table_association" "private_az2_1" {
  subnet_id      = aws_subnet.private_az2_1.id
  route_table_id = aws_route_table.private_az2.id
}
resource "aws_route_table_association" "private_az2_2" {
  subnet_id      = aws_subnet.private_az2_2.id
  route_table_id = aws_route_table.private_az2.id
}
