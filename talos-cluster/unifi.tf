resource "unifi_dns_record" "cluster" {
  count = local.register_dns_records && var.dns.provider == "unifi" ? length(local.cluster_sans) : 0

  name        = local.cluster_sans[count.index]
  enabled     = true
  record_type = "A"
  ttl         = 300
  value       = var.cluster_vip
  port        = 0
}
