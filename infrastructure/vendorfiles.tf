resource "proxmox_virtual_environment_file" "vendor_file_control" {
  node_name    = "pve02"
  datastore_id = "local"
  content_type = "snippets"

  source_raw {
    file_name = "vendor-cp-leader.yaml"
    data = templatefile("${path.module}/templates/vendor.yaml.tmpl", {
      vm_user     = var.vm_user,
      ssh_pub_key = var.vm_ssh_pub_key
    })
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "proxmox_virtual_environment_file" "vendor_file_worker" {
  node_name    = "pve03"
  datastore_id = "local"
  content_type = "snippets"

  source_raw {
    file_name = "vendor-cp-leader.yaml"
    data = templatefile("${path.module}/templates/vendor.yaml.tmpl", {
      vm_user     = var.vm_user,
      ssh_pub_key = var.vm_ssh_pub_key
    })
  }

  lifecycle {
    prevent_destroy = false
  }
}
