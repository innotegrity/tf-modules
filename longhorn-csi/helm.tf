resource "kubernetes_namespace_v1" "longhorn_csi" {
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

resource "helm_release" "longhorn_csi" {
  name       = "longhorn"
  chart      = "longhorn"
  repository = "https://charts.longhorn.io"

  atomic           = true
  cleanup_on_fail  = true
  create_namespace = false
  namespace        = var.namespace

  version = var.longhorn_csi_helm_version

  values = [yamlencode(local.helm_values)]
}
