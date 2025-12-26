variable "longhorn_csi_helm_version" {
  type        = string
  description = "Version of the Helm chart to use for installing the Longhorn CSI driver."
  default     = "1.10.1"
}

variable "namespace" {
  type        = string
  description = "The name of the namespace to create for the CSI driver resources."
  default     = "longhorn-system"
  validation {
    condition     = length(var.namespace) > 0
    error_message = "A namespace is required."
  }
}

variable "storage_classes" {
  type = list(object({
    name                   = string
    allow_volume_expansion = optional(bool, true)
    reclaim_policy         = optional(string, "Delete")
    parameters             = optional(map(string), {})
    mount_options          = optional(list(string), [])
  }))
  description = "Storage classes to add to the Kubernetes cluster."
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
