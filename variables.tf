variable "username_vsphere" {
  type        = string
  description = "username for vsphere"
}

variable "password_vsphere" {
  type        = string
  description = "password for vsphere"
  sensitive = true
}

variable "url_vsphere" {
  type        = string
  description = "url for vsphere"
}

variable "ssh_public_key" {
  type        = string
}

variable "ssh_private_key" {
  type        = string
}

variable "vsphere_datacenter" {}

variable "vsphere_resource_pool" {}

variable "vsphere_datastore" {}

variable "vsphere_network" {}

variable "vsphere_virtual_machine_template" {}

variable "vsphere_virtual_machine_name" {}

variable "vsphere_folder_path" {}
