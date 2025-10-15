resource "proxmox_virtual_environment_download_file" "debian_img_pve02" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "pve02"
  url          = "https://cdimage.debian.org/images/cloud/trixie/20251006-2257/debian-13-genericcloud-amd64-20251006-2257.qcow2"
  file_name    = "debian.qcow2"
}

resource "proxmox_virtual_environment_download_file" "debian_img_pve03" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "pve03"
  url          = "https://cdimage.debian.org/images/cloud/trixie/20251006-2257/debian-13-genericcloud-amd64-20251006-2257.qcow2"
  file_name    = "debian.qcow2"
}
