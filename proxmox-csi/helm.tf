resource "kubernetes_namespace_v1" "proxmox_csi" {
  metadata {
    name = "proxmox-csi"

    labels = {
      "pod-security.kubernetes.io/enforce" = "privileged"
    }
  }
}

resource "helm_release" "proxmox_csi" {
  name       = "proxmox-csi"
  chart      = "proxmox-csi-plugin"
  repository = "oci://ghcr.io/sergelogvinov/charts"

  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  namespace        = kubernetes_namespace_v1.proxmox_csi.metadata[0].name

  version = "0.5.3"

  values = [yamlencode(local.values)]
}
