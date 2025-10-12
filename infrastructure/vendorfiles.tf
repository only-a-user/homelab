resource "proxmox_virtual_environment_file" "vendor_file_pve02" {
  node_name    = "pve02"
  datastore_id = "local"
  content_type = "snippets"

  source_raw {
    file_name = "vendor.yaml"
    data = templatefile("${path.module}/templates/vendor.yaml.tmpl", {
      vm_user     = var.vm_user,
      ssh_pub_key = var.vm_ssh_pub_key
    })
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "proxmox_virtual_environment_file" "vendor_file_pve03" {
  node_name    = "pve03"
  datastore_id = "local"
  content_type = "snippets"

  source_raw {
    file_name = "vendor.yaml"
    data = templatefile("${path.module}/templates/vendor.yaml.tmpl", {
      vm_user     = var.vm_user,
      ssh_pub_key = var.vm_ssh_pub_key
    })
  }

  lifecycle {
    prevent_destroy = false
  }
}
