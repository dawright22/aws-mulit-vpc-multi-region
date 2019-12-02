
# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  type    = string
  default = "ssh-keypair-aws"
}

variable "create" {
  default = true
}

variable "create_vpc" {
  description = "Controls if VPC should be created (it affects almost all resources)"
  type        = bool
  default     = true
}

variable "ami_id" {
  description = "The ID of the AMI to run in the cluster. This should be an AMI built from the Packer template under examples/vault-consul-ami/vault-consul.json. If no AMI is specified, the template will 'just work' by using the example public AMIs. WARNING! Do not use the example AMIs in a production setting!"
  type        = string
  default     = null
}

variable "region" {
  type        = string
  description = "The name of the region you wish to deploy into"
  default     = "ap-southeast-1"
}

variable "aws_region-1" {
  type        = string
  description = "The name of the region you wish to deploy into"
  default     = "ap-southeast-2"
}

variable "resource_name" {
  type        = "string"
  description = "unique name for your resources"
  default     = "transit_VPC_"
}

variable "cidr_c" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.2.0.0/16"
}

variable "cidr_shared_services" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.1.0.0/16"
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.2.30.0/24", "10.2.40.0/24", "10.2.50.0/24"]
}

