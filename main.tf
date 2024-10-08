provider "vsphere" {
  user                 = var.username_vsphere
  password             = var.password_vsphere
  vsphere_server       = var.url_vsphere
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_virtual_machine_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Use external data source to run the Bash script and capture the VM name
data "external" "generate_vm_name" {
  program = ["bash", "generate_name.sh"]

  # No inputs are needed for this script, so we provide an empty map
  query = {}
}

# Use the result of the external data source for the VM name
locals {
  vm_name = data.external.generate_vm_name.result.name
}

resource "vsphere_virtual_machine" "web-server" {
  name             = local.vm_name
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  folder           = var.vsphere_folder_path

  num_cpus = data.vsphere_virtual_machine.template.num_cpus
  memory   = data.vsphere_virtual_machine.template.memory
  guest_id = data.vsphere_virtual_machine.template.guest_id

  scsi_type = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = local.vm_name
        domain    = "local"
      }

      network_interface {
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.0.20.1"
    }
  }
}
