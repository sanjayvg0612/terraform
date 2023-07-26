data "aws_availability_zones" "available" {
   state = "available"
}

locals {
       ingress_rules = [{
          description = "port-443"
          port = 443
        
   },
   {
     description = "port-80"
      port = 80
   }]
}



