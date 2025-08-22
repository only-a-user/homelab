locals {
  controlplane_names = ["talos-control-plane"]
  worker_names       = ["talos-worker"]
}

resource "talos_machine_secrets" "cluster" {}

resource "talos_machine_configuration" "controlplane" {
  cluster_id  = talos_machine_secrets.cluster.cluster_id
  secrets     = talos_machine_secrets.cluster.secrets
  cluster_name = "homelab-cluster"
  machine_type = "controlplane"
  docs = true
  node = {
    hostname = "talos-control-plane"
    ip       = var.proxmox_nodes["talos-control-plane"].ip
    gateway  = var.gateway
  }
}

resource "talos_machine_configuration" "worker" {
  cluster_id  = talos_machine_secrets.cluster.cluster_id
  secrets     = talos_machine_secrets.cluster.secrets
  cluster_name = "homelab-cluster"
  machine_type = "worker"
  docs = true
  node = {
    hostname = "talos-worker"
    ip       = var.proxmox_nodes["talos-worker"].ip
    gateway  = var.gateway
  }
}

output "controlplane_config" {
  value = talos_machine_configuration.controlplane.machine_configuration
}

output "worker_config" {
  value = talos_machine_configuration.worker.machine_configuration
}
