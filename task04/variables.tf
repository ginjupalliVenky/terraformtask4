variable "rg_name" {
  description = "The name of the existing resource group"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "nic_name" {
  description = "The name of the network interface"
  type        = string
}

variable "nsg_name" {
  description = "The name of the Network Security Group"
  type        = string
}

variable "nsg_rule_http" {
  description = "The name of the HTTP NSG rule"
  type        = string
}

variable "nsg_rule_ssh" {
  description = "The name of the SSH NSG rule"
  type        = string
}

variable "public_ip_name" {
  description = "The name of the public IP address"
  type        = string
}

variable "domain_name_label" {
  description = "The domain name label for the public IP"
  type        = string
}

variable "vm_name" {
  description = "The name of the virtual machine"
  type        = string
}

variable "vm_sku" {
  description = "The size/sku of the virtual machine"
  type        = string
}

variable "vm_username" {
  description = "The admin username for the virtual machine"
  type        = string
}

variable "vm_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}

variable "creator" {
  description = "The email or name of the creator to use in tags"
  type        = string
}

variable "my_ip" {
  description = "Your public IP address for SSH/HTTP NSG rules"
  type        = string
}

variable "verification_ip" {
  description = "The verification IP used for HTTP rule"
  type        = string
  default     = "18.153.146.156"
}

variable "ip_config_name" {
  description = "ip config name"
  type        = string
}
