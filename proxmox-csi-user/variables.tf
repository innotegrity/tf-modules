variable "csi_password" {
  type        = string
  description = "Password for the Proxmox user which will be generated for accessing the APIs."
  sensitive   = true
}

variable "csi_role_name" {
  type        = string
  description = "Name of the role to create for Kubernetes CSI driver."
  default     = "KubernetesCSI"
}

variable "csi_token_name" {
  type        = string
  description = "The name of the API token to generate for the CSI user."
  default     = "csi"
}

variable "csi_username" {
  type        = string
  description = "Username for the Proxmox user which will be generated for accessing the APIs. Must be username@realm format."
  default     = "kubernetes-csi@pve"
}
