# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12"
}

module "region-1" {
  version = "1.0.0"
  source = "./region-1"
  region = "ap-southeast-2"
  # cidr_c = "10.2.0.0/16" #CIDR block used for VPC_C
}

module "region-2" {
  version = "1.0.0"
  source               = "./region-2"
  region               = "ap-southeast-1" #define the region for the secondary VPC
  aws_region-1         = "ap-southeast-2" #define the primary peering region
  cidr_shared_services = "10.1.0.0/16"    #CIDR block for the shared service VPC
}
