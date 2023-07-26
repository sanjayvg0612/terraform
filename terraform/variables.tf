variable "environment" {
  description = "Setup the environment name of the infra resource belongs to"
  type        = string
  default     = "dev"
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "name" {
  default = "ems"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}