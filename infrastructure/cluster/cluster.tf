resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "controlplane" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_machine_configuration" "worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.this.machine_secrets
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = [for k, v in var.cluster_nodes.controlplanes : v.ip]
}

resource "talos_machine_configuration_apply" "controlplane" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.controlplane.machine_configuration
  for_each                    = var.cluster_nodes.controlplanes
  node                        = each.value.ip
  config_patches = [
    templatefile("${path.module}/config/templates/machine-controlplane.yml.tmpl", {
      hostname     = each.key
      install_disk = each.value.install_disk
    }),
    templatefile("${path.module}/config/templates/cluster.yml.tmpl", {
      pod_network = var.pod_network
      svc_network = var.svc_network
    }),
  ]
}

resource "talos_machine_configuration_apply" "worker" {
  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker.machine_configuration
  for_each                    = var.cluster_nodes.workers
  node                        = each.value.ip
  config_patches = [
    templatefile("${path.module}/config/templates/machine-worker.yml.tmpl", {
      hostname     = each.key
      install_disk = each.value.install_disk
    })
  ]
}

resource "talos_machine_bootstrap" "this" {
  depends_on = [talos_machine_configuration_apply.controlplane]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.cluster_nodes.controlplanes : v.ip][0]
}

resource "talos_cluster_kubeconfig" "this" {
  depends_on           = [talos_machine_bootstrap.this]
  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = [for k, v in var.cluster_nodes.controlplanes : v.ip][0]
}
