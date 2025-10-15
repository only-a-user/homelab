# create the base vms
resource "proxmox_virtual_environment_vm" "nodes" {
  for_each = var.proxmox_nodes

  name = each.key
  tags = ["terraform", "debian", "k3s"]

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
    import_from  = strcontains(each.value.node, "pve02") ? proxmox_virtual_environment_download_file.debian_img_pve02.id : proxmox_virtual_environment_download_file.debian_img_pve03.id
    size         = each.value.disk
  }

  network_device {
    model       = "virtio"
    bridge      = "vmbr0"
    mac_address = each.value.mac
  }

  initialization {
    interface = "ide2"

    vendor_data_file_id = "local:snippets/${strcontains(each.value.node, "pve02") ? proxmox_virtual_environment_file.vendor_file_pve02.source_raw[0].file_name : proxmox_virtual_environment_file.vendor_file_pve03.source_raw[0].file_name}"

    user_account {
      username = var.vm_user
      password = var.vm_password
      keys     = [chomp(var.vm_ssh_pub_key)]
    }

    ip_config {
      ipv4 {
        address = each.value.ip
        gateway = var.gateway
      }
    }
  }

  lifecycle {
    ignore_changes = [initialization["user_account"]]
  }
}
