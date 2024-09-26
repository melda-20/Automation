output "vm_ip" {
  description = "Het IP-adres van de aangemaakte VM"
  value       = vsphere_virtual_machine.web-server.default_ip_address
}
