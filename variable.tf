variable "project"{

}
variable "env"{

}
variable "vpc_tags"{
    default = {}
}
variable "cidr_name" {
    default = "10.0.0.0/16"
}
variable "igw_tags"{
    default = {}
}

variable "cidr_block_public" {
   default = ["10.0.1.0/24","10.0.2.0/24"]
}

variable "public_subnet_tags" {
    default ={}
}

variable "cidr_block_backend" {
   default = ["10.0.11.0/24","10.0.22.0/24"]
}

variable "backend_subnet_tags" {
    default ={}
}

variable "cidr_block_database" {
   default = ["10.0.14.0/24","10.0.15.0/24"]
}

variable "database_subnet_tags" {
    default ={}
}

variable "publicroute_tags" {
    default = {}
}

variable "databaseroute_tags" {
    default = {}
}

variable "backendroute_tags" {
    default = {}
}

variable "eip_tags" {
    default = { }
}

variable "nat_tags" {
    default = {}
}