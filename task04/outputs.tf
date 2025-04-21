output "vm_public_ip" {
  description = "Public IP address of the virtual machine"
  value       = azurerm_public_ip.this.ip_address
}

output "vm_fqdn" {
  description = "FQDN of the virtual machine"
  value       = azurerm_public_ip.this.fqdn
}