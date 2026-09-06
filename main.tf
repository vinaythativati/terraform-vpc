resource "aws_vpc" "main" {
  cidr_block       = var.cidr_name
  enable_dns_support = true

  tags = merge(var.vpc_tags,local.common_name,
  {
    Name = "${var.project}-${var.env}-vpc"
  })
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.igw_tags, local.common_name,
  {
    Name = "${var.project}-${var.env}-IGW"
  })
}

resource "aws_subnet" "public" {
  count = length(var.cidr_block_public)
  vpc_id     = aws_vpc.main.id
    map_public_ip_on_launch = true
  cidr_block = var.cidr_block_public[count.index]
  availability_zone =  local. availability_zone[count.index]
  tags =  merge(var.public_subnet_tags, local.common_name,
  {
    Name ="${var.project}-${var.env}-public-subnet-${split("-" ,local.availability_zone[count.index])[2]}"
  })
}

resource "aws_subnet" "backend" {
  count = length(var.cidr_block_backend)
  vpc_id     = aws_vpc.main.id
    map_public_ip_on_launch = false
  cidr_block = var.cidr_block_backend[count.index]
  availability_zone =  local. availability_zone[count.index]
  tags =  merge(var.backend_subnet_tags, local.common_name,
  {
    Name ="${var.project}-${var.env}-backend-subnet-${split("-" ,local.availability_zone[count.index])[2]}"
  })
}

resource "aws_subnet" "database" {
  count = length(var.cidr_block_database)
  vpc_id     = aws_vpc.main.id
    map_public_ip_on_launch = false
  cidr_block = var.cidr_block_database[count.index]
  availability_zone =  local. availability_zone[count.index]
  tags =  merge(var.database_subnet_tags, local.common_name,
  {
    Name ="${var.project}-${var.env}-database-subnet-${split("-" ,local.availability_zone[count.index])[2]}"
  })
}

resource "aws_route_table" "public_route" {
 vpc_id = aws_vpc.main.id
tags =  merge(var.publicroute_tags, local.common_name,
  {
    Name ="${var.project}-${var.env}-public-route"
  })
}

resource "aws_route_table" "backend_route" {
  vpc_id = aws_vpc.main.id

  
tags =  merge(var.backendroute_tags, local.common_name,
  {
    Name ="${var.project}-${var.env}-backend-route"
  })
}

resource "aws_route_table" "database_route" {
  vpc_id = aws_vpc.main.id

  
tags =  merge(var.databaseroute_tags, local.common_name,
  {
    Name ="${var.project}-${var.env}-database-route"
  })
}

resource "aws_route_table_association" "public" {
   count = length(var.cidr_block_public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "database" {
   count = length(var.cidr_block_database)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database_route.id
}

resource "aws_route_table_association" "backend" {
   count = length(var.cidr_block_backend)
  subnet_id      = aws_subnet.backend[count.index].id
  route_table_id = aws_route_table.backend_route.id
}

resource "aws_eip" "lb" {
  domain   = "vpc"
  tags =  merge(var.eip_tags, local.common_name,
  {
    Name ="${var.project}-${var.env}-elastic-ip"
  })

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.public[0].id

  tags =  merge(var.nat_tags, local.common_name,
  {
    Name ="${var.project}-${var.env}-NAT"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "r" {
  route_table_id            = aws_route_table.public_route.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
 
}

resource "aws_route" "ro" {
  route_table_id            = aws_route_table.backend_route.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
 
}

resource "aws_route" "ru" {
  route_table_id            = aws_route_table.database_route.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat.id
 
}