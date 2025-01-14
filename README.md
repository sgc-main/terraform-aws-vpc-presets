# AWS VPC Presets Module

This Terraform module serves as a friendly Data Source, allowing the usage of AMI, VPC and Subnets Names, retrieving the corresponding ID.

- AMI: 
  - Retrieves AMIs in the account where it is executed and also AMIs shared with the account from the Management AWS Account
  - Allows the specification of a full name or a wildcard name
  - Retrieves the most recent finding from a list of AMIs
- VPC and Subnets:
  - Translates the friendly name to coresponding IDs

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

### Resources

| Name | Type |
|------|------|
| [aws_ami.ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet.subnet_ids](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet) | data source |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

### Examples

main.tf  
```hcl

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
```  

### Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| <a name="input_ami_architecture"></a> [ami\_architecture](#input\_ami\_architecture) | AMI Architecture | `string` | `"x86_64"` |
| <a name="input_ami_name"></a> [ami\_name](#input\_ami\_name) | AMI Name Tag | `string` | `""` |
| <a name="input_ami_owners"></a> [ami\_owners](#input\_ami\_owners) | AMI Owners List | `string` | `""` |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Comma separated string of subnet name tags | `string` | `""` |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC Name Tag | `string` | `""` |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_ami_id"></a> [ami\_id](#output\_ami\_id) | AMI ID. |
| <a name="output_ami_ids"></a> [ami\_ids](#output\_ami\_ids) | AMI ID list. |
| <a name="output_az_ids"></a> [az\_ids](#output\_az\_ids) | List of Availability Zones for Subnets. |
| <a name="output_cidr_blocks"></a> [cidr\_blocks](#output\_cidr\_blocks) | List of CIDR Blocks for the used Subnets. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | List of Subnet IDs. |
| <a name="output_vpc_cidr"></a> [vpc\_cidr](#output\_vpc\_cidr) | VPC CIDR Block. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC ID. |
<!-- END_TF_DOCS -->