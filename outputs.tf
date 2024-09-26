output "vm_ip" {
  description = "The IP-adres of the new VM"
  value       = vsphere_virtual_machine.web-server.default_ip_address
}
