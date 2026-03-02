### PROXMOX ###

variable "nodes" {
  type = map(object({
    id     = string
    node   = string
    ip     = string
    mac    = string
    memory = string
    disk   = string
  }))
}

variable "gateway" { type = string }
variable "dns" { type = string }
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

### TALOS ###

variable "cluster_name" { type = string }
variable "cluster_endpoint" { type = string } # the clusters virtual ip

variable "pod_network" { type = string }
variable "svc_network" { type = string }

variable "cluster_nodes" {
  type = object({
    controlplanes = map(object({
      ip           = string
      install_disk = string
    }))
    workers = map(object({
      ip           = string
      install_disk = string
    }))
  })
}
