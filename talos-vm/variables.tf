variable "boot_disk" {
  type = object({
    cache_mode   = optional(string, "none")
    size         = optional(number, null)
    ssd          = optional(bool, false)
    storage_pool = string
  })
  description = "The configuration for the VM's boot disk."
  validation {
    condition     = contains(["none", "directsync", "writethrough", "writeback", "unsafe"], var.boot_disk.cache_mode)
    error_message = "'disk_cache_mode' must be one of: none, directsync, writethrough, writeback or unsafe"
  }
}

variable "cluster_role" {
  type        = string
  description = "The role of the node within the Talos cluster."
  validation {
    condition     = contains(["control-plane", "worker"], var.cluster_role)
    error_message = "'cluster_role' must be one of: control-plane or worker"
  }
  default = "worker"
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores to assign to the VM. If null, uses defaults based on the cluster role."
  default     = null
}

variable "dhcp" {
  type = object({
    provider           = string
    ip_address         = string
    mac_address        = optional(string, null)
    mac_address_prefix = optional(list(number), [02, 01, 01])
    reserve_hostname   = optional(bool, false)
  })
  validation {
    condition     = contains(["unifi"], var.dhcp.provider)
    error_message = "'dhcp.provider' must be unifi"
  }
  default = null
}

variable "enable_longhorn" {
  type        = bool
  description = "Whether or not to enable this VM as a Longhorn storage node."
  default     = false
}

variable "extra_disks" {
  type = list(object({
    cache_mode   = optional(string, "none")
    interface    = string
    size         = number
    ssd          = optional(bool, false)
    storage_pool = string
  }))
  validation {
    condition = alltrue([
      for obj in var.extra_disks : contains(["none", "directsync", "writethrough", "writeback", "unsafe"], obj.cache_mode)
    ])
    error_message = "'cache_mode' must be one of: none, directsync, writethrough, writeback or unsafe"
  }
  validation {
    condition = alltrue([
      for obj in var.extra_disks : startswith(obj.interface, "scsi") && obj.interface != "scsi0" && var.enable_longhorn ? obj.interface != "scsi1" : true
    ])
    error_message = "'interface' must start with 'scsi' and may not be 'scsi0' or 'scsi1' (if 'enable_longhorn' is true)"
  }
  default = []
}

variable "hostname" {
  type        = string
  description = "The hostname to use for the VM."
  validation {
    condition     = length(var.hostname) > 0
    error_message = "'hostname' must be a non-empty string"
  }
}

variable "longhorn_disk" {
  type = object({
    cache_mode   = optional(string, "none")
    size         = optional(number, 250)
    ssd          = optional(bool, false)
    storage_pool = optional(string, null)
  })
  description = "The configuration for the Longhorn storage disk -- ignored unless 'enable_longhorn' is true"
  validation {
    condition     = var.enable_longhorn ? try(var.longhorn_disk.storage_pool, null) != null : true
    error_message = "'storage_pool' is required when 'enable_longhorn' is true"
  }
  validation {
    condition     = var.enable_longhorn ? contains(["none", "directsync", "writethrough", "writeback", "unsafe"], try(var.longhorn_disk.cache_mode, null)) : true
    error_message = "'disk_cache_mode' must be one of: none, directsync, writethrough, writeback or unsafe"
  }
  default = null
}

variable "memory" {
  type        = number
  description = "The amount of memory (in GB) to allocate to the VM. If null, uses defaults based on the cluster role."
  default     = null
}

variable "network_bridge" {
  type        = string
  description = "The network interface / bridge to use for the VM."
}

variable "proxmox_node" {
  type        = string
  description = "The node within the Proxmox cluster to use when deploying the VM."
}

variable "proxmox_pool" {
  type        = string
  description = "The name of the Proxmox pool in which to place the VM."
  default     = null
}

variable "talos_iso_file_id" {
  type        = string
  description = "ID for the Talos ISO file to use when deploying the VM."
}

variable "vm_id" {
  type        = string
  description = "The unique ID to use for the virtual machine or null to use the next available ID."
  default     = null
}

variable "vm_tags" {
  type        = list(string)
  description = "List of tags to apply the the VM."
  default     = []
}
