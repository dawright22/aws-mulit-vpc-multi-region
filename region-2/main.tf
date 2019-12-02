# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
# ----------------------------------------------------------------------------------------------------------------------
terraform {
  required_version = ">= 0.12.0"
}

# ---------------------------------------------------------------------------------------------------------------------
# Set the AWS REGION
# ---------------------------------------------------------------------------------------------------------------------

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "accepter"
  region = var.aws_region-1
}

data "aws_availability_zones" "all" {}

data "aws_vpc" "vpc_shared_services_vpc" {
  provider = "aws.accepter"
  filter {
    name   = "tag:Name"
    values = ["${var.resource_name}shared_services"]
  }
  depends_on = ["module.vpc_c.vpc_id"]
}

data "aws_route_table" "vpc_shared_services" {
  provider   = "aws.accepter"
  depends_on = ["aws_vpc_peering_connection.peer"]
  vpc_id     = "${data.aws_vpc.vpc_shared_services_vpc.id}"
  filter {
    name   = "tag:Name"
    values = ["${var.resource_name}shared_services"]
  }
}

data "aws_route_table" "vpc_c" {
  depends_on = ["aws_vpc_peering_connection.peer"]
  vpc_id     = "${module.vpc_c.vpc_id}"
  filter {
    name   = "tag:Name"
    values = ["${var.resource_name}C"]
  }
}
#----------------
#create ssh key
#_________________

module "ssh_keypair_aws" {
  source = "github.com/dawright22/hashicorp-modules/ssh-keypair-aws"
  create = "${var.create}"
  name   = "${var.name}-region-2"
}

# ---------------------------------------------------------------------------------------------------------------------
# Create the basic network via terrafrom registery VPC module
# ---------------------------------------------------------------------------------------------------------------------

module "vpc_c" {
  source     = "github.com/terraform-aws-modules/terraform-aws-vpc"
  create_vpc = var.create_vpc
  name       = "${var.resource_name}C"
  cidr       = var.cidr_c

  enable_dns_hostnames = true
  enable_dns_support   = true

  azs            = data.aws_availability_zones.all.names
  public_subnets = var.public_subnets
  tags = {
    Terraform = "true"
    Name      = "${var.resource_name}C"
  }
}


# Add routes for intra-region  VPC routing
resource "aws_route" "route_vpc_c_to_shared_services" {
  route_table_id            = "${data.aws_route_table.vpc_c.id}"
  destination_cidr_block    = var.cidr_shared_services
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

resource "aws_route" "route_vpc_shared_services_to_vpc_c" {
  provider                  = "aws.accepter"
  route_table_id            = "${data.aws_route_table.vpc_shared_services.id}"
  destination_cidr_block    = var.cidr_c
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
}

#Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = "${module.vpc_c.vpc_id}"
  peer_vpc_id = "${data.aws_vpc.vpc_shared_services_vpc.id}"
  auto_accept = false
  peer_region = var.aws_region-1

  tags = {
    Side = "Requester"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider                  = "aws.accepter"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  auto_accept               = true

  tags = {
    Side = "Accepter"
    Name = "${var.resource_name}shared_services"
  }
}

# resource "aws_vpc_peering_connection_options" "requester" {
#   provider = "aws.requester"

#   # As options can't be set until the connection has been accepted
#   # create an explicit dependency on the accepter.
#   vpc_peering_connection_id = "${aws_vpc_peering_connection_accepter.peer.id}"

#   requester {
#     allow_remote_vpc_dns_resolution = true
#   }
# }

# resource "aws_vpc_peering_connection_options" "accepter" {
#   provider = "aws.accepter"

#   vpc_peering_connection_id = "${aws_vpc_peering_connection_accepter.peer.id}"

#   accepter {
#     allow_remote_vpc_dns_resolution = true
#   }
# }
