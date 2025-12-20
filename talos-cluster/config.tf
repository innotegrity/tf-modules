resource "talos_machine_secrets" "this" {}

data "talos_machine_configuration" "control_plane" {
  for_each = local.control_plane_nodes

  cluster_endpoint   = "https://${local.master_endpoint}:6443"
  cluster_name       = var.cluster_name
  config_patches     = each.value.patches
  docs               = false
  examples           = false
  kubernetes_version = var.k8s_version
  machine_type       = "controlplane"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version
}

data "talos_machine_configuration" "worker" {
  for_each = local.worker_nodes

  cluster_endpoint   = "https://${local.master_endpoint}:6443"
  cluster_name       = var.cluster_name
  config_patches     = each.value.patches
  docs               = false
  examples           = false
  kubernetes_version = var.k8s_version
  machine_type       = "worker"
  machine_secrets    = talos_machine_secrets.this.machine_secrets
  talos_version      = var.talos_version
}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  nodes                = local.node_ips
  endpoints            = local.endpoint_ips
}

resource "talos_machine_configuration_apply" "control_plane" {
  for_each = local.control_plane_nodes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.control_plane[each.key].machine_configuration
  node                        = each.value.ip_address
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = local.worker_nodes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[each.key].machine_configuration
  node                        = each.value.ip_address
}
