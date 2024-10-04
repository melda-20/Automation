output "vm_ip" {
  value = vsphere_virtual_machine.web-server.default_ip_address
}