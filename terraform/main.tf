data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = data.aws_vpc.default.id
}

locals {
  eligible_subnet_ids = [
    for id, s in data.aws_subnet.public :
    id if !contains(var.excluded_availability_zones, s.availability_zone)
  ]
}

resource "aws_instance" "yogesh_demo" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = sort(local.eligible_subnet_ids)[0]
  vpc_security_group_ids      = [data.aws_security_group.default.id]
  associate_public_ip_address = true

  tags = {
    Name = "yogesh_demo"
  }
}
