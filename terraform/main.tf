module "vpc" {
  source                 = "./modules/terraform-aws-vpc"
  cidr                   = var.vpc_cidr
  name                   = "${var.name}-${var.environment}"
  nat_per_az             = false
  separate_db_subnets    = true
  subnet_outer_offsets   = [2,4,8]
  subnet_inner_offsets   = [2,4,8]
  transit_gateway_attach = false
   allow_cidrs_default    = {}
  transit_gateway_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      transit_gateway_id     = "0"
    }
  ]

  environment            = var.environment
}

module "ec2_instance" {
  source = "./modules/terraform-aws-ec2"
  
    
  
  
  
}