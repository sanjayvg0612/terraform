variable "subnet_outer_offsets" {
  type        = list(number)
  default     = [2,4,8]
  
}

variable "subnet_inner_offsets" {
  type        = list(number)
  default     = [2,4,8]

}

variable "nat_per_az" {
  default = false
}

locals {
  nat_count = var.nat_per_az ? length(local.subnet_list[0]) : 1
}


variable "allow_cidrs_default" {
  type    = map(string)
  default = {
    cidr_block = "10.1.0.0/16"
  }
}


variable "cidr" {
  default = "10.1.0.0/16"
}

variable "separate_db_subnets" {
    type    = bool
    default = true
  
}

variable "skip_az" {
  type    = number
  default = 10
}

variable "route_count" {
  description = "Number of routes to create"
  type        = number
  default     = 10 # Provide a default value or change it based on your requirements
}

variable "name" {
  description = "Name for the resource"
  type        = string
  default     = "demo"  # Provide a default value or change it based on your requirements
}

variable "environment" {
  description = "Name for the resource"
  type        = string
  default     = "dev"  # Provide a default value or change it based on your requirements
}

variable "transit_gateway_attach" {
  description = "Flag to indicate transit gateway attachment"
  type        = bool
  default     = false  # Provide a default value or change it based on your requirements
}
variable "transit_gateway_routes" {
  type = list(object({
    destination_cidr_block = string
    transit_gateway_id     = string
  }))
  default = [
    {
      destination_cidr_block = "0.0.0.0/0"
      transit_gateway_id     = "value"
    }
  ]
}

variable "transit_gateway_id" {
  description = "ID of the transit gateway"
  type        = string
  default     = " "  # Provide a default value or change it based on your requirements
}
variable "tags" {
  
type = string
default = "subnet"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}