# Configure the VMware NSX-T Provider
provider "nsxt" {
  host                 = "nsxmgr-01a"
  username             = "admin"
  password             = "VMware1!VMware1!"
  allow_unverified_ssl = true
}


provider "vsphere" {
  user           = "administrator@vsphere.local"
  password       = "VMware1!"
  vsphere_server = "vcsa-01a.corp.local"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}


data "vsphere_datacenter" "datacenter" {
  name = "Site-A"
}

data "vsphere_virtual_machine" "web-01a" {
  name          = "web-01a"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_virtual_machine" "web-02a" {
  name          = "web-02a"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_virtual_machine" "app-01a" {
  name          = "app-01a"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_virtual_machine" "db-01a" {
  name          = "db-01a"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

data "vsphere_virtual_machine" "lb-01a" {
  name          = "lb-01a"
  datacenter_id = "${data.vsphere_datacenter.datacenter.id}"
}

resource "nsxt_vm_tags" "web-01a_tags" {
  instance_id = "${data.vsphere_virtual_machine.web-01a.id}"

  tag {
    scope = "webapp"
    tag   = "web"
  }
}

resource "nsxt_vm_tags" "web-02a_tags" {
  instance_id = "${data.vsphere_virtual_machine.web-02a.id}"

  tag {
    scope = "webapp"
    tag   = "web"
  }
}

resource "nsxt_vm_tags" "app-01a_tags" {
  instance_id = "${data.vsphere_virtual_machine.app-01a.id}"

  tag {
    scope = "webapp"
    tag   = "app"
  }
}

resource "nsxt_vm_tags" "db-01a_tags" {
  instance_id = "${data.vsphere_virtual_machine.db-01a.id}"

  tag {
    scope = "webapp"
    tag   = "db"
  }
}

resource "nsxt_vm_tags" "lb-01a_tags" {
  instance_id = "${data.vsphere_virtual_machine.lb-01a.id}"

  tag {
    scope = "webapp"
    tag   = "lb"
  }
}

