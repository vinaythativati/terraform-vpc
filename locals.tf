locals {
project = "roboshop"
env = "dev"
terraform = "true"
availability_zone = slice(data.aws_availability_zones.available.names, 0 ,2)
 common_name = {
          component = "vpc"
          terraform = "true"
    }

 }
  

