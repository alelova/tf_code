variable "miaws_instance_type" {
  type    = string
  default = "t2.nano"
}
variable "miaws_key" {
  type    = string
}
variable "security_groups" {
  type =list(string)
}
variable "web_subnet"{
  type = string
}
variable "web_app" {
  type = string
}

