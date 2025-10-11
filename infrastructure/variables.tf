variable "gateway" { type = string }
variable "network" { type = string }

variable "proxmox_user" {
  type      = string
  sensitive = true
}
variable "proxmox_password" {
  type      = string
  sensitive = true
}
variable "proxmox_endpoint" { type = string }

variable "vm_user" { type = string }
variable "vm_ssh_pub_key" {
  type      = string
  sensitive = true
}
variable "vm_password" {
  type      = string
  sensitive = true
}

variable "proxmox_nodes" {
  type = map(object({
    id          = string
    node        = string
    ip          = string
    mac         = string
    template_id = string
  }))
}
