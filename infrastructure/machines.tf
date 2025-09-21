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

  cpu {
    cores   = 4
    sockets = 1
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = 14336
  }

  cdrom {
    file_id = proxmox_virtual_environment_download_file.talos_img[each.value.node].id
  }

  disk {
    datastore_id = "local-lvm"
    interface    = "scsi0"
    size         = 128
  }

  network_device {
    model       = "virtio"
    bridge      = "vmbr0"
    mac_address = each.value.mac
  }
}
