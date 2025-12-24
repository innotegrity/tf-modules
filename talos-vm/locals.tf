locals {
  vm_description = var.cluster_role == "control-plane" ? "Talos Control Plane" : "Talos Worker"
  vm_role_tag    = var.cluster_role == "control-plane" ? "control-plane" : "worker"
  vm_tags        = distinct(concat(["opentofu-managed", "k8s", local.vm_role_tag], coalesce(var.vm_tags, [])))

  cpu_cores = coalesce(var.cpu_cores, var.cluster_role == "control-plane" ? 4 : 8)
  memory    = coalesce(var.memory, (var.cluster_role == "control-plane" ? 8 : 32) * 1024)
  disk_size = coalesce(var.boot_disk.size, var.cluster_role == "control-plane" ? 50 : 100)

  generate_random_mac = (var.dhcp != null && var.dhcp.mac_address == null)
  mac_address         = (var.dhcp == null) ? null : (local.generate_random_mac ? resource.macaddress.talos_node[0].address : var.dhcp.mac_address)
}
