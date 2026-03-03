# create the base vms
resource "proxmox_virtual_environment_vm" "nodes" {
  for_each = var.nodes

  name = each.key
  tags = ["terraform", "talos", "k8s"]

  node_name = each.value.node
  vm_id     = each.value.id

  on_boot         = true
  stop_on_destroy = true

  # wether to use the qemu agent
  agent {
    enabled = true
  }

  cpu {
    cores   = 4
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    file_format  = "raw"
    import_from  = "local:import/talos.raw" # for some reason the image nees to lay on the same proxmox node, otherwise it cant be supplied to the vm
    size         = each.value.disk
  }

  dynamic "disk" {
    for_each = each.value.additional_disk > 0 ? [1] : []
    content {
      datastore_id = "local-lvm"
      interface    = "scsi1"
      size         = each.value.additional_disk
    }
  }

  network_device {
    model       = "virtio"
    bridge      = "vmbr0"
    mac_address = each.value.mac
  }

  initialization {
    interface = "ide2"

    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.gateway
      }
    }

    dns {
      servers = [var.dns]
    }
  }
}
