# VPC A
output "VPC_A_id" {
  description = "The ID of the VPC"
  value       = module.VPC_region-1.vpc_a_vpc_id
}

# Subnets
output "VPC_A_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.region-1.vpc_a_public_subnets
}

# VPC B
output "VPC_B_id" {
  description = "The ID of the VPC"
  value       = module.region-1.vpc_b_vpc_id
}

# Subnets
output "VPC_B_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.region-1.vpc_b_public_subnets
}

# VPC shared services
output "vpc_shared_service_vpc" {
  description = "The ID of the VPC"
  value       = module.region-1.vpc_shared_services_vpc_id
}

# Subnets
output "vpc_shared_service_public_subnets" {
  description = "List of IDs of private subnets"
  value       = module.region-1.vpc_shared_services_public_subnets
}

# VPC C
output "VPC_C_id" {
  description = "The ID of the VPC"
  value       = module.region-2.vpc_id
}

# SSH keys

output "VPC_C_private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.region-2.public_subnets
}


output "private_key_name-1" {
  value = module.region-1.private_key_name
}

output "private_key_filename-1" {
  value = module.region-1.private_key_filename
}

output "ssh_key_name-1" {
  value = module.region-1.ssh_key_name
}

output "private_key_name-2" {
  value = module.region-2.private_key_name
}

output "private_key_filename-2" {
  value = module.region-2.private_key_filename
}

output "ssh_key_name-2" {
  value = module.region-2.ssh_key_name
}

output "zREADME" {
  value = <<README
A private RSA key has been generated and downloaded locally. The file permissions have been changed to 0600 so the key can be used immediately for SSH or scp.
Run the below command to add this private key to the list maintained by ssh-agent so you're not prompted for it when using SSH or scp to connect to hosts with your public key.
  ${format("ssh-add %s", module.VPC_region-1.private_key_filename)}
The public part of the key loaded into the agent ("public_key_openssh" output) must be placed on the target system in ~/.ssh/authorized_keys.
To SSH into the target host using this private key, you can use the below command after updating USER@HOST.
  ${format("ssh -i %s USER@HOST", module.region-1.private_key_filename)} for region-1 instances and ${format("ssh -i %s USER@HOST", module.region-2.private_key_filename)} for region-2 instances
To force the generation of a new key, the private key instance can be "tainted" using the below command.
  terraform taint -module=ssh_keypair_aws.tls_private_key tls_private_key.key
README
}


