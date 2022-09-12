
variable "project_name" {
  description = "kreuzwerker"
}
 
variable "environment" {
  description = "The deployment environment"
  default     = "development"
}
 
variable "region" {
  description = "default region"
}
 
variable "availability_zones" {
  type        = list(any)
  description = "list of availability zones"
}

variable "enable_nat_gateway"{
    type        = bool
    description = "nat gw switch"
    default     = false
}

variable "single_nat_gateway"{
    type        = bool
    description = "single nat switch"
    default     = false
}

variable "manage_default_network_acl"{
    type        = bool
    description = "manage network acl"
    default     = false
}

variable "manage_default_route_table"{
    type        = bool
    description = "manage route table"
    default     = false
}

variable "enable_ipv6"{
    type        = bool
    description = "manage route table"
    default     = true
}

variable "reuse_nat_ips"{
    type        = bool
    description = "skip eip creation"
    default     = true
}
 
variable "vpc_cidr" {
  description = "CIDR block of vpc"
}
variable "public_subnet_az1_cidr" {
  description = "CIDR block of pub sub 1"
}
variable "public_subnet_az2_cidr" {
  description = "CIDR blcok of pub sub 2"
}
variable "private_app_subnet_az1_cidr" {
  description = "CIDR block of prv app sub 1"
}
variable "private_app_subnet_az2_cidr" {
  description = "CIDR block of prv app sub 2"
}
variable "private_data_subnet_az1_cidr" {
  description = "CIDR block of prv data sub 1"
}
variable "private_data_subnet_az2_cidr" {
  description = "CIDR block of prv data sub 2"
}
 
variable "public_subnets_cidr" {
  type        = list(any)
  description = "CIDR list of pub subs"
}
 
variable "private_subnets_cidr" {
  type        = list(any)
  description =  "CIDR list of orv subs"
}