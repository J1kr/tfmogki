resource "aws_vpc" "tenv" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = {
    Name = "tenv"
  }
}


# Subnets
resource "aws_subnet" "tenv-public-1" {
  vpc_id                  = aws_vpc.tenv.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-northeast-2a"

  tags = {
    Name = "tenv-public-1"
  }
}
resource "aws_subnet" "tenv-public-2" {
  vpc_id                  = aws_vpc.tenv.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-northeast-2b"

  tags = {
    Name = "tenv-public-2"
  }
}
resource "aws_subnet" "tenv-public-3" {
  vpc_id                  = aws_vpc.tenv.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-northeast-2c"

  tags = {
    Name = "tenv-public-3"
  }
}
# Internet GW
resource "aws_internet_gateway" "tenv-gw" {
  vpc_id = aws_vpc.tenv.id

  tags = {
    Name = "tenv"
  }
}

# route tables
resource "aws_route_table" "tenv-public" {
  vpc_id = aws_vpc.tenv.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tenv-gw.id
  }

  tags = {
    Name = "tenv-public-1"
  }
}

# route associations public
resource "aws_route_table_association" "tenv-public-1-a" {
  subnet_id      = aws_subnet.tenv-public-1.id
  route_table_id = aws_route_table.tenv-public.id
}
resource "aws_route_table_association" "tenv-public-2-a" {
  subnet_id      = aws_subnet.tenv-public-2.id
  route_table_id = aws_route_table.tenv-public.id
}
resource "aws_route_table_association" "tenv-public-3-a" {
  subnet_id      = aws_subnet.tenv-public-3.id
  route_table_id = aws_route_table.tenv-public.id
}

/* Private Not USE
 resource "aws_subnet" "tenv-private-1" {
  vpc_id                  = aws_vpc.tenv.id
  cidr_block              = "10.1.0.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-northeast-2a"

  tags = {
    Name = "tenv-private-1"
  }
}
resource "aws_subnet" "tenv-private-2" {
  vpc_id                  = aws_vpc.tenv.id
  cidr_block              = "10.2.1.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-northeast-2b"

  tags = {
    Name = "tenv-private-2"
  }
}
resource "aws_subnet" "tenv-private-3" {
  vpc_id                  = aws_vpc.tenv.id
  cidr_block              = "10.3.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-northeast-2c"

  tags = {
    Name = "tenv-private-3"
  }
}

 resource "aws_route_table" "tenv-private" {
  vpc_id = aws_vpc.tenv.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "tenv-private-1"
  }
}
# route associations private
resource "aws_route_table_association" "tenv-private-1-a" {
  subnet_id      = aws_subnet.tenv-private-1.id
  route_table_id = aws_route_table.tenv-private.id
}
resource "aws_route_table_association" "tenv-private-2-a" {
  subnet_id      = aws_subnet.tenv-private-2.id
  route_table_id = aws_route_table.tenv-private.id
}
resource "aws_route_table_association" "tenv-private-3-a" {
  subnet_id      = aws_subnet.tenv-private-3.id
  route_table_id = aws_route_table.tenv-private.id
}
# nat gw
resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.tenv-public-1.id
  depends_on    = [aws_internet_gateway.tenv-gw]
} */