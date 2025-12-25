locals {
  cluster_configs = [{
    url          = "https://${var.proxmox_host}:${var.proxmox_port}/api2/json"
    insecure     = var.proxmox_skip_verify_tls
    token_id     = "${var.csi_token_id}"
    token_secret = "${var.csi_token_secret}"
    region       = "${var.proxmox_cluster}"
  }]

  storage_classes = [for class in var.storage_classes :
    {
      name            = class.name
      storage         = class.storage_pool
      reclaimPolicy   = class.reclaim_policy
      fstype          = class.fs_type
      cache           = class.cache_mode
      ssd             = class.ssd
      extraParameters = class.extra_parameters
      mountOptions    = class.mount_options
    }
  ]

  values = {
    config = {
      clusters = local.cluster_configs
    }
    storageClass = local.storage_classes
  }
}
