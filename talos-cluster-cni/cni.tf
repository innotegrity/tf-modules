data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = var.client_configuration
  nodes                = concat(var.control_plane_nodes, var.worker_nodes)
  endpoints            = var.endpoints
}

data "http" "gateway_crds" {
  url = local.gateway_crds_url
}

resource "kubernetes_manifest" "gateway_crds" {
  manifest = local.gateway_crds_manifest
}

resource "helm_release" "cilium_cni" {
  depends_on = [
    kubernetes_manifest.gateway_crds
  ]

  repository = "https://helm.cilium.io"
  chart      = "cilium"
  name       = "cilium-cni"

  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true
  namespace        = "kube-system"
  version          = var.cilium_helm_version

  set = [
    {
      name  = "ipam.mode"
      value = "kubernetes"
    },
    {
      name  = "kubeProxyReplacement"
      value = true
    },
    {
      name  = "securityContext.capabilities.ciliumAgent"
      value = "{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}"
    },
    {
      name  = "securityContext.capabilities.cleanCiliumState"
      value = "{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}"
    },
    {
      name  = "cgroup.autoMount.enabled"
      value = false
    },
    {
      name  = "cgroup.hostRoot"
      value = "/sys/fs/cgroup"
    },
    {
      name  = "k8sServiceHost"
      value = "localhost"
    },
    {
      name  = "k8sServicePort"
      value = 7445
    },
    {
      name  = "gatewayAPI.enabled"
      value = true
    },
    {
      name  = "gatewayAPI.enableAlpn"
      value = true
    },
    {
      name  = "gatewayAPI.enableAppProtocol"
      value = true
    },
    {
      name  = "gatewayAPI.gatewayClass.create"
      type  = "string"
      value = "true"
    },
    {
      name  = "l2announcements.enabled"
      value = true
    },
    {
      name  = "k8sClientRateLimit.qps"
      value = 50
    },
    {
      name  = "k8sClientRateLimit.burst"
      value = 200
    },
    {
      name  = "operator.rollOutPods"
      value = true
    },
    {
      name  = "rollOutCiliumPods"
      value = true
    },
    {
      name  = "ingressController.enabled"
      value = true
    }
  ]
}

data "talos_cluster_health" "this" {
  depends_on = [
    helm_release.cilium_cni
  ]

  client_configuration   = data.talos_client_configuration.this.client_configuration
  control_plane_nodes    = var.control_plane_nodes
  worker_nodes           = var.worker_nodes
  endpoints              = var.endpoints
  skip_kubernetes_checks = true
  timeouts = {
    read = "5m"
  }
}
