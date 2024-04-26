variable "vpc_cidr" {
  description = "cidr"
  type        = string

}

variable "public_subnets" {
  description = "public-subnet cidr"
  type        = list(string)

}

variable "private_subnets" {
  description = "private-subnet cidr"
  type        = list(string)

}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string

}