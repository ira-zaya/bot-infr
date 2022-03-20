# =========| PUBLIC SUBNETS |=========
resource "aws_subnet" "public-subnet" {
  count = length(var.public-subnet-cidr)
  cidr_block              = tolist(var.public-subnet-cidr)[count.index]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.vpc
  ]

  tags      = {
    Name    = "${var.environment}-publicSubnet-${count.index + 1}"
    AvZones = data.aws_availability_zones.available.names[count.index]
    Env     = "${var.environment}-publicSubnet"
  }
}

# =====================================
resource "aws_subnet" "private-subnet" {
  count = length(var.private-subnet-cidr)
  cidr_block              = tolist(var.private-subnet-cidr)[count.index]
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  depends_on = [
    aws_vpc.vpc
  ]

  tags      = {
    Name    = "${var.environment}-privateSubnet-${count.index + 1}"
    AvZones = data.aws_availability_zones.available.names[count.index]
    Env     = "${var.environment}-privateSubnet"
  }
}

# =====================================