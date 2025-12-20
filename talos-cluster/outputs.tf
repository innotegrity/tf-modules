output "talos_machine_secrets" {
  description = "Machine secrets used for the Talos cluster"
  value       = talos_machine_secrets.this
  sensitive   = true
}

output "talos_config_file_contents" {
  description = "Contents to add to talosctl configuration file"
  value       = data.talos_client_configuration.this.talos_config
  sensitive   = true
}

output "kubeconfig_file_contents" {
  description = "Raw Kubernetes configuration file data"
  value       = talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive   = true
}

output "kubeconfig" {
  description = "Kubernetes client configuration"
  value       = talos_cluster_kubeconfig.kubeconfig.kubernetes_client_configuration
  sensitive   = true
}
