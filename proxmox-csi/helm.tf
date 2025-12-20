resource "kubernetes_namespace_v1" "proxmox_csi" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = local.namespace

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
  namespace        = var.create_namespace ? kubernetes_namespace_v1.proxmox_csi[0].metadata[0].name : local.namespace

  version = "0.5.3"

  values = [yamlencode(local.values)]
}
