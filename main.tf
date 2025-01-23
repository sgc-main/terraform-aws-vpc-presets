locals {
  ami_names  = compact(split(",", var.ami_name))
  ami_owners = compact(split(",", var.ami_owners))
  subnets    = compact(split(",", var.subnets))
}

data "aws_ami" "ami" {
  for_each = toset(local.ami_names)
  filter {
    name   = "state"
    values = ["available"]
  }
  filter {
    name   = "architecture"
    values = [var.ami_architecture]
  }
  filter {
    name   = "name"
    values = [each.key]
  }

  dynamic "filter" {
    for_each = var.custom_ami_filters
    content {
      name   = filter.key
      values = filter.value
    }
  }

  owners      = concat(["self"], local.ami_owners)
  most_recent = true
}

data "aws_vpc" "vpc" {
  for_each = var.vpc_name != "" ? toset([var.vpc_name]) : []
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
}

data "aws_subnet" "subnet_ids" {
  for_each = var.vpc_name != "" && length(local.subnets) > 0 ? toset(local.subnets) : []
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc[var.vpc_name].id]
  }
  filter {
    name   = "tag:Name"
    values = [each.key]
  }
}
