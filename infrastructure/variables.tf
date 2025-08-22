variable "proxmox_endpoint"   { type = string }
variable "proxmox_user"      { type = string }
variable "proxmox_password"  { type = string }

variable "talos_version" {
  type    = string
  default = "1.10.6"
}

variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
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
  default = {
    controlplanes = {
      "10.5.0.2" = {
        install_disk = "/dev/sda"
      },
      "10.5.0.3" = {
        install_disk = "/dev/sda"
      },
      "10.5.0.4" = {
        install_disk = "/dev/sda"
      }
    }
    workers = {
      "10.5.0.5" = {
        install_disk = "/dev/nvme0n1"
        hostname     = "worker-1"
      },
      "10.5.0.6" = {
        install_disk = "/dev/nvme0n1"
        hostname     = "worker-2"
      }
    }
  }
}

# proxmox
variable "proxmox_nodes" {
  type = map(object({
    node = string
    ip   = string
  }))

  default = {
    "talos-control-plane" = { node = "pve01", ip = "10.20.30.11/24" }
    "talos-worker" = { node = "pve02", ip = "10.20.30.12/24" }
  }
}

variable "gateway" {
  type = string
  default = "10.20.30.1"
}
