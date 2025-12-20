variable "arch" {
  type        = string
  description = "The system architecture version for the image file."
  validation {
    condition     = contains(["amd64", "arm64"], var.arch)
    error_message = "'arch' must be one of: amd64 or arm64"
  }
  default = "amd64"
}

variable "extra_extensions" {
  type        = list(string)
  description = "A list of extra extensions to include in the image file."
  default     = []
}

variable "extra_kernel_args" {
  type        = list(string)
  description = "A list of extra kernel arguments to pass on startup."
  default     = []
}

variable "proxmox_node" {
  type        = string
  description = "The node within the Proxmox cluster to use to download the image file."
}

variable "storage_pool" {
  type        = string
  description = "The storage pool in which to store the downloaded image file."
}

variable "talos_version" {
  type        = string
  description = "The version of Talos to download."
}
