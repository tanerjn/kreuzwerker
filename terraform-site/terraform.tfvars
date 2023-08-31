region                       = "us-west-2"
project_name                 = "kreuzwerker"
vpc_cidr                     = "10.0.0.0/16"

public_subnet_az1_cidr       = "10.0.10.0/24"
public_subnet_az2_cidr       = "10.0.20.0/24"

private_app_subnet_az1_cidr  = "10.0.30.0/24"
private_app_subnet_az2_cidr  = "10.0.40.0/24"
private_data_subnet_az1_cidr = "10.0.50.0/24"
private_data_subnet_az2_cidr = "10.0.60.0/24"

zones                        = ["us-west-2a", "us-west-2b"]
private_subnets              = ["10.0.30.0/24", "10.0.40.0/24", "10.0.50.0/24", "10.0.60.0/24"]
public_subnets               = ["10.0.10.0/24", "10.0.20.0/24"]

enable_nat_gateway           = true
single_nat_gateway           = false
manage_default_network_acl   = false
manage_default_route_table   = false
enable_ipv6 			     = true
reuse_nat_ips 			     = true


