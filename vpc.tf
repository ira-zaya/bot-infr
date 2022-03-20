# =========| VPC |=========
data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.environment}-vpc"
  }
}
# ============================


# =========| INTERNET GATEWAY |=========

# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Demo Internet Gateway"
  }
}
# ======================================



# =========| ROUTE TABLES |=========
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.default-cidr #0.0.0.0/0
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# =========================================
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  count  = 2
  route {
    cidr_block     = var.default-cidr
    nat_gateway_id = element(aws_nat_gateway.nat-gateway.*.id, count.index)
  }

  tags = {
    Name = "Private Route Table ${count.index + 1}"
  }
}
# ================================



# =========| ROUTE TABLE ASSOCIATIONS |===========

resource "aws_route_table_association" "public-subnet-route-table-association" {
  count          = 2
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-subnet-route-table-association" {
  count          = 2
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = element(aws_route_table.private-route-table.*.id, count.index)
}

# =================================================
