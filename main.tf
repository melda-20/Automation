terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.0"
    }
  }
}

provider "vsphere" {
  user                 = var.username_vsphere
  password             = var.password_vsphere
  vsphere_server       = var.url_vsphere
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Netlab-DC"
}

data "vsphere_datastore" "datastore" {
  name          = "NIM01-I3-DB"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Netlab-Cluster-B"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "rp" {
  name          = "I3-DB01-RP"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "2718_I483725_PVlanA"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "Templ_Ubuntu-Linux_Server_22.04.4"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Creation of VM by cloning template
resource "vsphere_virtual_machine" "web-server" {
  name             = "web-server"
  resource_pool_id = data.vsphere_resource_pool.rp.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 2048
  guest_id = "otherGuest64"

  network_interface {
    network_id   = data.vsphere_network.network.id
    #adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  disk {
    label            = "disk0"
    size             = 32
    eagerly_scrub    = false
    thin_provisioned = true
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = "web-server"
        domain    = "local"
      }

      network_interface {
        ipv4_address = "10.0.10.100"  # Adjust to match your network configuration
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.0.10.1"  # Adjust based on your gateway
    }
  }
}
