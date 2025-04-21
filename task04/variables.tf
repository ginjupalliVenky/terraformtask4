variable "rg_name" {}
variable "vnet_name" {}
variable "subnet_name" {}
variable "nic_name" {}
variable "nsg_name" {}
variable "nsg_rule_http" {}
variable "nsg_rule_ssh" {}
variable "public_ip_name" {}
variable "domain_name_label" {}
variable "vm_name" {}
variable "vm_sku" {}
variable "vm_username" {}
variable "vm_password" {
  sensitive = true
}
variable "creator" {}
variable "my_ip" {}
variable "verification_ip" {
  default = "18.153.146.156"
}