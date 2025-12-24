variable "cluster_name" {
  type        = string
  description = "The name to use for the Talos cluster."
}

variable "cluster_sans" {
  type        = list(string)
  description = "One or more SANs to add to the cluster's API server certificate."
  default     = []
}

variable "cluster_vip" {
  type        = string
  description = "Virtual IP to use for the main cluster endpoint, if any."
  default     = null
}

variable "control_plane_nodes" {
  type = map(object({
    annotations = optional(map(string), {})
    hostname    = string
    ip_address  = string
    labels      = optional(map(string), {})
    extra_disks = optional(map(object({
      name        = string
      device_name = string
      format      = optional(string, "ext4")
    })), {})
  }))
  description = "A map of control plane nodes for the cluster."
  validation {
    error_message = "At least 1 control plane node is required"
    condition     = length(var.control_plane_nodes) > 0
  }
}

variable "dns" {
  type = object({
    provider = string
  })
  description = "Optional configuration for registering DNS records for the cluster."
  validation {
    condition     = contains(["unifi"], var.dns.provider)
    error_message = "'provider' must be 'unifi'"
  }
  default = null
}

variable "k8s_version" {
  type        = string
  description = "Version of Kubernetes to deploy."
}

variable "oidc_config" {
  type = object({
    issuer_url     = string
    client_id      = string
    username_claim = optional(string, "email")
    groups_claim   = optional(string, "groups")
    groups_prefix  = optional(string, "oidc:")
  })
  description = "Optional OIDC configuration for k8s cluster authentication."
  default     = null
}

variable "talos_installer_image_id" {
  type        = string
  description = "The ID of the container installer image to use for the initial installation to disk."
}

variable "talos_version" {
  type        = string
  description = "Version of Talos to use for the generated machine configuration."
}

variable "worker_nodes" {
  type = map(object({
    annotations = optional(map(string), {})
    hostname    = string
    ip_address  = string
    labels      = optional(map(string), {})
    extra_disks = optional(map(object({
      name        = string
      device_name = string
      format      = optional(string, "ext4")
    })), {})
  }))
  description = "A map of worker nodes for the cluster."
  validation {
    error_message = "At least 1 worker node is required"
    condition     = length(var.worker_nodes) > 0
  }
}
