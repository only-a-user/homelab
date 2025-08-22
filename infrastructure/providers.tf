terraform {
  required_version = ">= 1.12.2"
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.81.0"
    }
    talos = {
      source = "siderolabs/talos"
      version = "0.8.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  username = var.proxmox_user
  password = var.proxmox_password
  insecure = true
}

provider "talos" {}
