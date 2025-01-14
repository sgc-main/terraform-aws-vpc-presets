
terraform {
  backend "s3" {}
}

variable vpc_presets {
  type = map
  default = {
    AmiName     = "Ubuntu*"
    VpcName     = "vpc-1"
    SubnetNames = "subnet-1,subnet-2"
  }
}

variable tags {
  type = map
  default = {
      ProjectName    = "Test EC2"
      Environment    = "POC"
      Classification = "INF"
  }
}

module "vpc_presets" {
  source   = "sgc-main/vpc-presets/aws"
  vpc_name = lookup(var.vpc_presets, "VpcName")
  subnets  = lookup(var.vpc_presets, "SubnetNames")
  ami_name = lookup(var.vpc_presets, "AmiName")
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "test-instance"
  description = "test-instance"
  vpc_id      = module.vpc_presets.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/8"]
  ingress_rules       = ["ssh-tcp", "http-80-tcp", "https-443-tcp"]
  egress_rules        = ["all-all"]
  tags                = var.tags

}

module "ec2-1" {
  source = "sgc-main/ec2/aws"

  ami                    = module.vpc_presets.ami_id
  subnet_ids             = module.vpc_presets.subnet_ids
  vpc_security_group_ids = [module.security_group.security_group_id]
  instance_count         = 1
  server_prefix          = "test-instance"
  server_suffix          = "domain.fqdn"
  instance_type          = "t3.medium"
  enable_qualys          = "true"
  tags                   = var.tags
}
