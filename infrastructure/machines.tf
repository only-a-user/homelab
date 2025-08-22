# create the base vms
resource "proxmox_virtual_environment_vm" "talos" {
  for_each   = var.proxmox_nodes

  name       = each.key
  vm_id      = each.key == "talos-control-plane" ? 201 : 202
  node_name  = each.value.node
  on_boot    = true

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_download_file.talos_img[each.value.node].id
    interface    = "scsi0"
    size         = 8
  }

  disk {
    datastore_id = "local-lvm"
    interface = "scsi1"
    size = 128
  }

  memory {
    dedicated = 14336
  }

  cpu {
    cores = 4
    sockets = 1
    type = "host"
  }

  cloudinit {
    user_data = each.key == "talos-control-plane" ? talos_machine_configuration.controlplane.machine_configuration : talos_machine_configuration.worker.machine_configuration
  }

  network_device {
    model  = "virtio"
    bridge = "vmbr0"
  }

  agent {
    enabled = true
  }
}
