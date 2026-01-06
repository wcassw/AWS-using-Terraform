variable "vpc_id"       { 
    type = string 
}
variable "db_subnet_ids" { 
    type = list(string) 
}

variable "app_sg_id"    { 
    type = string 
}
variable "db_name"      { 
    type = string 
}
variable "instance_cls" { 
    type = string 
}

variable "db_identifier" {
    type = string
}
