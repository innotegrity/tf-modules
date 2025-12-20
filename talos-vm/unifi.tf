resource "unifi_user" "talos_node" {
  count = (var.dhcp != null && var.dhcp.provider == "unifi") ? 1 : 0

  name             = var.hostname
  mac              = local.mac_address
  fixed_ip         = var.dhcp.ip_address
  local_dns_record = (var.dhcp.reserve_hostname) ? var.hostname : null
}
