variable "region" {}
variable "project_name" {}
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}
variable "zones"{}
variable "public_subnets"{}
variable "private_subnets"{}
variable "enable_nat_gateway"{}
variable "single_nat_gateway"{}
variable "manage_default_network_acl"{}
variable "manage_default_route_table"{}
variable "enable_ipv6" {}
variable "reuse_nat_ips"{}