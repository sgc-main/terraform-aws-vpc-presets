output "ami_id" {
  description = "AMI ID."
  value = try(data.aws_ami.ami[local.ami_names[0]].id, "")
}

output "ami_platform" {
  description = "AMI OS Type."
  value = try(
    data.aws_ami.ami[local.ami_names[0]].platform_details == "Windows" ? "win" :
    data.aws_ami.ami[local.ami_names[0]].platform_details == "Linux/UNIX" ? "lnx" : "unknown",
    ""
  )
}

output "ami_ids" {
  description = "AMI ID list."
  value = [for ami in data.aws_ami.ami : ami.id]
}

output "vpc_id" {
  description = "VPC ID."
  value = try(data.aws_vpc.vpc[var.vpc_name].id, "")
}

output "vpc_cidr" {
  description = "VPC CIDR Block."
  value = try(data.aws_vpc.vpc[var.vpc_name].cidr_block, "")
}

output "subnet_ids" {
  description = "List of Subnet IDs."
  value = [for s in data.aws_subnet.subnet_ids : s.id]
}

output "az_ids" {
  description = "List of Availability Zones for Subnets."
  value = [for s in data.aws_subnet.subnet_ids : s.availability_zone]
}

output "cidr_blocks" {
  description = "List of CIDR Blocks for the used Subnets."
  value = [for s in data.aws_subnet.subnet_ids : s.cidr_block]
}