variable "region" {
    type = string
}

variable "vpc_cidr_block" {
    type = string
}

variable "all_cidr" {
    type = string
}

variable "public_subnet1_cidr" {
    type = string
}

variable "public_subnet2_cidr" {
    type = string
}

variable "private_subnet1_cidr" {
    type = string
}

variable "private_subnet2_cidr" {
    type = string
}

variable "availability_zone" {
    type = string
}
variable "availability_zone2" {
    type = string
}

variable "jenkins_port" {
    type = string
}
variable "sonarqube_port" {
    type = string
}
variable "ansible_port" {
    type = string
}
variable "grafana_port" {
    type = string
}
variable "http_port" {
    type = string
}

variable "https_port" {
    type = string
}

variable "ssh_port" {
    type = string
}

variable "key_name" {
    type = string
}

variable "key_secret" {
    type = string
}

variable "instance_ami" {
    type = string
}

variable "instance_type" {
    type = string
}