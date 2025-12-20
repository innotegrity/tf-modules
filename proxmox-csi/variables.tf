variable "csi_token_id" {
  type        = string
  description = "The ID of the Proxmox token for the CSI driver to use."
}

variable "csi_token_secret" {
  type        = string
  description = "The secret value of the Proxmox token for the CSI driver to use."
}

variable "proxmox_cluster" {
  type        = string
  description = "The name of the Proxmox cluster."
}

variable "proxmox_host" {
  type        = string
  description = "The hostname or IP address of the Proxmox server."
}

variable "proxmox_port" {
  type        = number
  description = "The port number for the Proxmox server."
  default     = 8006
}

variable "proxmox_skip_verify_tls" {
  type        = bool
  description = "Whether to skip TLS verification when connecting to the Proxmox server."
  default     = false
}

variable "storage_classes" {
  type = list(object({
    name             = string
    storage_pool     = string
    reclaim_policy   = optional(string, "Delete")
    fs_type          = optional(string, "ext4")
    cache_mode       = optional(string, "none")
    ssd              = optional(bool, false)
    extra_parameters = optional(map(string), {})
    mount_options    = optional(list(string), [])
  }))
  description = "Storage classes to add to the Kubernetes cluster where the key is used as the storage class name."
  validation {
    condition     = alltrue([for class, obj in var.storage_classes : contains(["Delete", "Retain"], obj.reclaim_policy) ? true : false])
    error_message = "'reclaim_policy' must be one of 'Delete' or 'Retain'."
  }
  validation {
    condition     = alltrue([for class, obj in var.storage_classes : contains(["ext4", "xfs"], obj.fs_type) ? true : false])
    error_message = "'fs_type' must be one of 'ext4' or 'xfs'."
  }
  validation {
    condition     = alltrue([for class, obj in var.storage_classes : contains(["none", "directsync", "writeback", "writethrough"], obj.cache_mode) ? true : false])
    error_message = "'cache_mode' must be one of 'none', 'directsync', 'writeback', or 'writethrough'."
  }
  default = []
}
