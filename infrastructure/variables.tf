variable "proxmox_endpoint" { type = string }
variable "proxmox_user" { type = string }
variable "proxmox_password" { type = string }

variable "talos_version" {
  type    = string
  default = "v1.11.1"
}

variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "cluster_network" {
  description = "The endpoint for the Talos cluster"
  type        = string
}

variable "node_data" {
  description = "A map of node data"
  type = object({
    controlplanes = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
    workers = map(object({
      install_disk = string
      hostname     = optional(string)
    }))
  })
}

variable "node_ips" {
  type = set(string)
}

# proxmox
variable "proxmox_nodes" {
  type = map(object({
    node = string
    ip   = string
    mac  = string
  }))
}

variable "gateway" {
  type    = string
  default = "192.168.1.0"
}
