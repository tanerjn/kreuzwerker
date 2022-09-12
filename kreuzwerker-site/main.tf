#configure aws provider 

provider "aws" { 
	region 				     = var.region
	profile 				 = "terraform-user"
}

#Create vpc 
module "vpc" {

	source 	= "../modules/vpc"
	region  = var.region
	availability_zones = ["us-west-2a", "us-west-2b"]

	project_name = var.project_name 
	vpc_cidr = var.vpc_cidr

	public_subnet_az1_cidr = var.public_subnet_az1_cidr
	public_subnet_az2_cidr = var.public_subnet_az2_cidr

	private_app_subnet_az1_cidr = var.private_app_subnet_az1_cidr
	private_app_subnet_az2_cidr = var.private_app_subnet_az2_cidr
	
	private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
	private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr

	enable_nat_gateway 		   = true
	single_nat_gateway   	   = false
	manage_default_network_acl = false
	manage_default_route_table = false
	enable_ipv6 			   = true
	reuse_nat_ips              = true # <= Skip creation of EIPs for the NAT Gateways

	public_subnets_cidr = ["10.0.10.0/24", "10.0.20.0/24"]
	private_subnets_cidr = ["10.0.30.0/24", "10.0.40.0/24", "10.0.50.0/24", "10.0.60.0/24"]

}

output "cidr-pub-az1" {
  value = join("", [" PUB - AZ1:",var.public_subnet_az1_cidr , "",])
}
output "cidr-pub-az2" {
  value = join("", [" PUB - AZ2:",var.public_subnet_az2_cidr , "",])
}
output "cidr-prv-app-az1" {
  value = join("", [" PRV -APP- AZ1:",var.private_app_subnet_az1_cidr , "",])
}
output "cidr-prv-app-az2" {
  value = join("", [" PRV -APP- AZ2:",var.private_app_subnet_az2_cidr , "",])
}
output "cidr-prv-data-az1" {
  value = join("", [" PRV -DATA- AZ1:",var.private_data_subnet_az1_cidr , "",])
}
output "cidr-prv-data-az2" {
  value = join("", [" PUB -DATA- AZ2:", var.private_data_subnet_az2_cidr , "",])
}
