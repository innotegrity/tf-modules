output "csi_token_id" {
  description = "Token ID for use with Kubernetes CSI driver."
  value       = proxmox_virtual_environment_user_token.this.id
}

output "csi_token_secret" {
  description = "Token secret for use with Kubernetes CSI driver."
  value       = split("=", proxmox_virtual_environment_user_token.this.value)[1]
}
