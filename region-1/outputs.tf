# VPC
output "vpc_a_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_a.vpc_id
}

output "aws_region-1" {
  description = "region 1 "
  value       = "${var.region}"
}
# Subnets
output "vpc_a_public_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_a.public_subnets
}

#vpc
output "vpc_b_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_b.vpc_id
}

# Subnets
output "vpc_b_public_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_b.public_subnets
}

#vpc
output "vpc_shared_services_vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc_shared_services.vpc_id
}

# Subnets
output "vpc_shared_services_public_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc_shared_services.public_subnets
}

output "transit_gateway_id" {
  value = aws_ec2_transit_gateway.region_A-tgw.id
}

output "zREADME" {
  value = <<README
A private RSA key has been generated and downloaded locally. The file permissions have been changed to 0600 so the key can be used immediately for SSH or scp.
Run the below command to add this private key to the list maintained by ssh-agent so you're not prompted for it when using SSH or scp to connect to hosts with your public key.
  ${format("ssh-add %s", module.ssh_keypair_aws.private_key_filename)}
The public part of the key loaded into the agent ("public_key_openssh" output) must be placed on the target system in ~/.ssh/authorized_keys.
To SSH into the target host using this private key, you can use the below command after updating USER@HOST.
  ${format("ssh -i %s USER@HOST", module.ssh_keypair_aws.private_key_filename)}
To force the generation of a new key, the private key instance can be "tainted" using the below command.
  terraform taint -module=ssh_keypair_aws.tls_private_key tls_private_key.key
README
}

output "private_key_name" {
  value = "${module.ssh_keypair_aws.private_key_name}"
}

output "private_key_filename" {
  value = "${module.ssh_keypair_aws.private_key_filename}"
}

output "private_key_pem" {
  value = "${module.ssh_keypair_aws.private_key_pem}"
}

output "public_key_pem" {
  value = "${module.ssh_keypair_aws.public_key_pem}"
}

output "public_key_openssh" {
  value = "${module.ssh_keypair_aws.public_key_openssh}"
}

output "ssh_key_name" {
  value = "${module.ssh_keypair_aws.name}"
}

