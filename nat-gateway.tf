# =========| EIP |=========
resource "aws_eip" "eip-for-nat-gateway" {
  vpc    = true
  count = length(var.eip)
  tags   = {
    Name = "${var.eip[count.index]}"
  }
}
# =========================


# =========| NAT GATEWAYS |=========
resource "aws_nat_gateway" "nat-gateway" {
  count = 2
  allocation_id = element(aws_eip.eip-for-nat-gateway.*.id, count.index)
  subnet_id     = element(aws_subnet.public-subnet.*.id, count.index)

  tags = {
    Name = "NAT Gateway Public Subnet ${count.index}"
  }
}
# =================================



