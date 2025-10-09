# create the base vms
resource "proxmox_virtual_environment_vm" "talos" {
  for_each = var.proxmox_nodes

  name = each.key
  tags = ["terraform", "talos", "k8s"]

  node_name = each.value.node
  vm_id     = each.key == "talos-control-plane" ? 201 : 202

  on_boot = true

  agent {
    enabled = true
  }
  stop_on_destroy = true

  boot_order = ["scsi0", "scsi1"]

  cpu {
    cores   = 4
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 12288
  }

  cdrom {
    file_id   = proxmox_virtual_environment_download_file.talos_img[each.value.node].id
    interface = "scsi1"
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 128
  }

  initialization {
    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.gateway
      }
    }
  }

  network_device {
    model       = "virtio"
    bridge      = "vmbr0"
    mac_address = each.value.mac
  }
}
