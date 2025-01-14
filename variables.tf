variable "ami_name" {
  description = "AMI Name Tag"
  default     = ""
}

variable ami_architecture {
  description = "AMI Architecture"
  default     = "x86_64"
}
variable ami_owners {
  description = "AMI Owners List"
  default     = ""
}

variable "subnets" {
  description = "Comma separated string of subnet name tags"
  default     = ""
}

variable "vpc_name" {
  description = "VPC Name Tag"
  default     = ""
}
