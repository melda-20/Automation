#terraform {
#  required_providers {
#    vsphere = {
#      source  = "hashicorp/vsphere"
#      version = ">= 2.0"
#    }
#  }
#}

provider "vsphere" {
  user                 = "${var.username_vsphere}"
  password             = "${var.password_vsphere}"
  vsphere_server       = "${var.url_vsphere}"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "${var.vsphere_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

#data "vsphere_compute_cluster" "cluster" {
#  name          = "${var.vsphere_compute_cluster}"
#  datacenter_id = "${data.vsphere_datacenter.dc.id}"
#}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_virtual_machine_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Creation of VM by cloning template
#machine name!!!!
resource "vsphere_virtual_machine" "cloned_virtual_machine" {
  name             = "${var.vsphere_virtual_machine_name}"
  resource_pool_id = "${data.vsphere_resource_pool.rp.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = "${data.vsphere_virtual_machine_template.num_cpus}"
  memory   = "${data.vsphere_virtual_machine_template.template.memory}"
  guest_id = "${data.vsphere_virtual_machine_template.guest_id}"

  scsi_type = "${data.vsphere_virtual_machine_template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine_template.disks.0.size}"
    thin_provisioned = true
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine_template.id}"

    #customize {
    #  linux_options {
    #    host_name = "web-server"
    #    domain    = "local"
    #  }

    #  network_interface {
    #    ipv4_address = "10.0.10.100"  # Adjust to match your network configuration
    #    ipv4_netmask = 24
    #  }

    #  ipv4_gateway = "10.0.10.1"  # Adjust based on your gateway
    #}
  }
}
