resource "kubernetes_manifest" "cilium_l2_announcement_policy" {
  manifest = {
    apiVersion = "cilium.io/v2alpha1"
    kind       = "CiliumL2AnnouncementPolicy"
    metadata = {
      name      = "default-l2-announcement-policy"
      namespace = "kube-system"
    }
    spec = {
      externalIPs     = true
      loadBalancerIPs = true
    }
  }
}

resource "kubernetes_manifest" "cilium_lb_ip_pool" {
  manifest = {
    apiVersion = "cilium.io/v2"
    kind       = "CiliumLoadBalancerIPPool"
    metadata = {
      name = "default-pool"
    }
    spec = {
      blocks = var.load_balancer_ip_blocks
    }
  }
}
