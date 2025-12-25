resource "kubernetes_namespace_v1" "proxmox_csi" {
  metadata {
    name = var.namespace

    labels = {
      "pod-security.kubernetes.io/enforce"         = "privileged"
      "pod-security.kubernetes.io/enforce-version" = "latest"
      "pod-security.kubernetes.io/audit"           = "privileged"
      "pod-security.kubernetes.io/audit-version"   = "latest"
      "pod-security.kubernetes.io/warn"            = "privileged"
      "pod-security.kubernetes.io/warn-version"    = "latest"
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
  namespace        = var.namespace

  version = "0.5.3"

  values = [yamlencode(local.values)]
}
