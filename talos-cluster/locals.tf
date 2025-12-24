locals {
  cluster_sans       = coalesce(var.cluster_sans, [])
  endpoint_ips       = [for node, config in var.control_plane_nodes : config.ip_address]
  endpoint_hostnames = [for node, config in var.control_plane_nodes : config.hostname]
  master_endpoint    = var.cluster_vip == null ? local.endpoint_ips[0] : var.cluster_vip
  node_ips           = concat(local.endpoint_ips, local.worker_ips)
  worker_ips         = [for node, config in var.worker_nodes : config.ip_address]

  register_dns_records = var.cluster_vip != null && var.dns != null && length(local.cluster_sans) > 0 ? true : false

  # config patches
  hostname_patch = { for node, config in merge(var.control_plane_nodes, var.worker_nodes) : node =>
    yamlencode({
      machine = {
        network = {
          hostname = config.hostname
        }
      }
    })
  }
  vip_disabled_patch = yamlencode({
    machine = {
      network = {
        interfaces = [
          {
            interface = "eth0"
            dhcp      = true
          }
        ]
      }
    }
  })
  vip_enabled_patch = yamlencode({
    machine = {
      network = {
        interfaces = [
          {
            interface = "eth0"
            dhcp      = true
            vip = {
              ip = "${var.cluster_vip}"
            }
          }
        ]
      }
    }
  })
  vip_patch = var.cluster_vip == null ? local.vip_disabled_patch : local.vip_enabled_patch
  dns_forwarding_patch = yamlencode({
    machine = {
      features = {
        hostDNS = {
          enabled              = true
          forwardKubeDNSToHost = true
          resolveMemberNames   = true
        }
      }
    }
  })
  install_image_patch = yamlencode({
    machine = {
      install = {
        disk  = "/dev/sda"
        image = var.talos_installer_image_id
      }
    }
  })
  cilium_cni_patch = yamlencode({
    cluster = {
      network = {
        cni = {
          name = "none"
        }
      }
      proxy = {
        disabled = true
      }
    }
  })
  oidc_patch = var.oidc_config == null ? null : yamlencode({
    cluster = {
      apiServer = {
        extraArgs = {
          oidc-issuer-url     = var.oidc_config.issuer_url
          oidc-client-id      = var.oidc_config.client_id
          oidc-username-claim = var.oidc_config.username_claim
          oidc-groups-claim   = var.oidc_config.groups_claim
          oidc-groups-prefix  = var.oidc_config.groups_prefix
        }
        certSANs = local.cluster_sans
      }
    }
  })
  kubeprism_patch = yamlencode({
    machine = {
      features = {
        kubePrism = {
          enabled = true
          port    = 7445
        }
      }
    }
  })


  # config for nodes
  control_plane_nodes = { for node, config in var.control_plane_nodes : node => {
    ip_address = config.ip_address
    hostname   = config.hostname
    patches = flatten([
      local.vip_patch,
      local.dns_forwarding_patch,
      local.install_image_patch,
      local.oidc_patch,
      local.hostname_patch[node],
      local.kubeprism_patch,
      local.cilium_cni_patch,
      yamlencode({
        machine = {
          nodeAnnotations = { for annotation, value in coalesce(config.annotations, {}) : annotation => value }
          nodeLabels      = { for label, value in coalesce(config.labels, {}) : label => value }
        }
      }),
      [for bus, disk in config.extra_disks : yamlencode({
        apiVersion = "v1alpha1"
        kind       = "UserVolumeConfig"
        name       = "${disk.name}"
        provisioning = {
          diskSelector = {
            match = "disk.dev == \"${disk.device_name}\""
          }
        }
        filesystem = {
          type = "${disk.format}"
        }
      })]
    ])
  } }

  worker_nodes = { for node, config in var.worker_nodes : node => {
    ip_address = config.ip_address
    hostname   = config.hostname
    patches = flatten([
      local.dns_forwarding_patch,
      local.install_image_patch,
      local.hostname_patch[node],
      local.kubeprism_patch,
      local.cilium_cni_patch,
      yamlencode({
        machine = {
          nodeAnnotations = { for annotation, value in coalesce(config.annotations, {}) : annotation => value }
          nodeLabels      = { for label, value in coalesce(config.labels, {}) : label => value }
        }
      }),
      [for bus, disk in config.extra_disks : yamlencode({
        apiVersion = "v1alpha1"
        kind       = "UserVolumeConfig"
        name       = "${disk.name}"
        provisioning = {
          diskSelector = {
            match = "disk.dev == \"${disk.device_name}\""
          }
        }
        filesystem = {
          type = "${disk.format}"
        }
      })]
    ])
  } }
}
