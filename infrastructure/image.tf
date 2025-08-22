# the talos image
# this will be used by the proxmox provider
resource "proxmox_virtual_environment_download_file" "talos_img" {
  # make available on each node
  for_each   = toset(distinct(values(var.proxmox_nodes)[*].node))
  node_name  = each.value
  storage    = "local-lvm"
  url        = "https://factory.talos.dev/image/88d1f7a5c4f1d3aba7df787c448c1d3d008ed29cfb34af53fa0df4336a56040b/${var.talos_version}/metal-amd64.qcow2"
  # for compatibility
  file_name  = "metal-amd64.img"
  content_type = "iso"
}
