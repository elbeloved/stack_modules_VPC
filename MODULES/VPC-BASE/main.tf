locals {
    ServerPrefix = ""
}

resource "aws_vpc" "stack" {
    cidr_block            =   var.cidr
    instance_tenancy      =   var.instance_tenancy
    enable_dns_hostnames  =   var.enable_dns_hostnames
    enable_dns_support    =   var.enable_dns_support
    
    tags = merge({Name    = "${local.ServerPrefix != "" ? local.ServerPrefix : "Stack_VPC"}"}, var.required_tags)
}

resource "aws_subnet" "public_stack" {
    vpc_id                  =   aws_vpc.stack.id
    availability_zone       =   var.subnet_availability_zone
    cidr_block              =   var.cidr_public_subnet
    map_public_ip_on_launch =   true

    tags = merge({Name      = "${local.ServerPrefix != "" ? local.ServerPrefix : "Stack_Pub_VPC"}"}, var.required_tags)
}

resource "aws_subnet" "public_stack_1b" {
    vpc_id                  =   aws_vpc.stack.id
    availability_zone       =   var.subnet_availability_zone_1b
    cidr_block              =   var.cidr_public_subnet_1b
    map_public_ip_on_launch =   true

    tags = merge({Name      = "${local.ServerPrefix != "" ? local.ServerPrefix : "Stack_Pub_VPC_1b"}"}, var.required_tags)
}

resource "aws_subnet" "private_stack" {
    count                   =   length(var.cidr_private_subnet)
    vpc_id                  =   aws_vpc.stack.id
    availability_zone       =   var.subnet_availability_zone
    cidr_block              =   var.cidr_private_subnet[count.index]
    map_public_ip_on_launch =   true

    tags = merge({Name    = "${local.ServerPrefix != "" ? local.ServerPrefix : "Stack_Pri_VPC"}${count.index}"}, var.required_tags)
}

resource "aws_subnet" "private_stack_1b" {
    count                   =   length(var.cidr_private_subnet_1b)
    vpc_id                  =   aws_vpc.stack.id
    availability_zone       =   var.subnet_availability_zone_1b
    cidr_block              =   var.cidr_private_subnet_1b[count.index]
    map_public_ip_on_launch =   true

    tags = merge({Name    = "${local.ServerPrefix != "" ? local.ServerPrefix : "Stack_Pri_VPC_1b"}${count.index}"}, var.required_tags)
}

resource "aws_nat_gateway" "stack" {
    allocation_id = aws_eip.stack.id
    subnet_id     = aws_subnet.public_stack.id  

    depends_on    = [aws_internet_gateway.stack]        
}

resource "aws_nat_gateway" "stack_1b" {
    allocation_id = aws_eip.stack_1b.id
    subnet_id     = aws_subnet.public_stack_1b.id

    depends_on    = [aws_internet_gateway.stack]
}

resource "aws_eip" "stack" {
    domain        = "vpc"
}

resource "aws_eip" "stack_1b" {
    domain        = "vpc"
}

resource "aws_internet_gateway" "stack" {
    vpc_id                =   aws_vpc.stack.id
    tags = merge({Name    =   "${local.ServerPrefix != "" ? local.ServerPrefix : "Stack_IGW"}"}, var.required_tags)
}

resource "aws_route_table" "public_stack" {
    vpc_id                =   aws_vpc.stack.id

    #attach IGW for ingress traffic for VPC
    route {
        cidr_block        =   "0.0.0.0/0"
        gateway_id        =   aws_internet_gateway.stack.id
    }

    #attach public subnets to route
    route {
        cidr_block        =   var.cidr
        gateway_id        =   "local"
    }
}

resource "aws_route_table" "public_stack_1b" {
    vpc_id                =   aws_vpc.stack.id

    #attach IGW for ingress traffic for VPC
    route {
        cidr_block        =   "0.0.0.0/0"
        gateway_id        =   aws_internet_gateway.stack.id
    }

    #attach public subnets to route
    route {
        cidr_block        =   var.cidr
        gateway_id        =   "local"
    }
}

resource "aws_route_table_association" "public_stack" {
    subnet_id       = aws_subnet.public_stack.id
    route_table_id  = aws_route_table.public_stack.id

    depends_on = [aws_subnet.public_stack]
}

resource "aws_route_table_association" "public_stack_1b" {
    subnet_id       = aws_subnet.public_stack_1b.id
    route_table_id  = aws_route_table.public_stack_1b.id

    depends_on = [aws_subnet.public_stack_1b]
}

resource "aws_route_table" "private_stack" {
    vpc_id                =   aws_vpc.stack.id

    #attach private subnets to route
    route {
        cidr_block        =   var.cidr
        gateway_id        =   "local"
    }

    route {
        cidr_block        =   "0.0.0.0/0"
        nat_gateway_id    =   aws_nat_gateway.stack.id        
    }

}

resource "aws_route_table" "private_stack_1b" {
    vpc_id                =   aws_vpc.stack.id

    #attach private subnets to route
    route {
        cidr_block        =   var.cidr
        gateway_id        =   "local"
    }

    route {
        cidr_block        =   "0.0.0.0/0"
        nat_gateway_id    =   aws_nat_gateway.stack_1b.id        
    }

}

resource "aws_route_table_association" "private_stack" {
    count           = length(var.cidr_private_subnet)
    subnet_id       = aws_subnet.private_stack[count.index].id
    route_table_id  = aws_route_table.private_stack.id

    depends_on = [aws_subnet.private_stack]
}

resource "aws_route_table_association" "private_stack_1b" {
    count           = length(var.cidr_private_subnet_1b)
    subnet_id       = aws_subnet.private_stack_1b[count.index].id
    route_table_id  = aws_route_table.private_stack_1b.id

    depends_on = [aws_subnet.private_stack_1b]
}


