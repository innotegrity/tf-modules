resource "kubernetes_storage_class_v1" "longhorn_ext4" {
  metadata {
    name = "longhorn-ext4"
  }
  storage_provisioner    = "driver.longhorn.io"
  allow_volume_expansion = true
  parameters = {
    numberOfReplicas    = 3
    staleReplicaTimeout = 2880
    fromBackup          = ""
    format              = "ext4"
  }
}

resource "kubernetes_storage_class_v1" "longhorn_ext4_retain" {
  metadata {
    name = "longhorn-ext4-retain"
  }
  storage_provisioner    = "driver.longhorn.io"
  allow_volume_expansion = true
  reclaim_policy         = "Retain"
  parameters = {
    numberOfReplicas    = 3
    staleReplicaTimeout = 2880
    fromBackup          = ""
    format              = "ext4"
  }
}

resource "kubernetes_storage_class_v1" "longhorn_ext4_encrypted" {
  metadata {
    name = "longhorn-ext4-encrypted"
  }
  storage_provisioner    = "driver.longhorn.io"
  allow_volume_expansion = true
  parameters = {
    numberOfReplicas                                   = 3
    staleReplicaTimeout                                = 2880
    fromBackup                                         = ""
    encrypted                                          = true
    format                                             = "ext4"
    "csi.storage.k8s.io/provisioner-secret-name"       = "$${pvc.name}-longhorn"
    "csi.storage.k8s.io/provisioner-secret-namespace"  = "$${pvc.namespace}"
    "csi.storage.k8s.io/node-publish-secret-name"      = "$${pvc.name}-longhorn"
    "csi.storage.k8s.io/node-publish-secret-namespace" = "$${pvc.namespace}"
    "csi.storage.k8s.io/node-stage-secret-name"        = "$${pvc.name}-longhorn"
    "csi.storage.k8s.io/node-stage-secret-namespace"   = "$${pvc.namespace}"
  }
}

resource "kubernetes_storage_class_v1" "longhorn_ext4_encrypted_retain" {
  metadata {
    name = "longhorn-ext4-encrypted-retain"
  }
  storage_provisioner    = "driver.longhorn.io"
  allow_volume_expansion = true
  reclaim_policy         = "Retain"
  parameters = {
    numberOfReplicas                                   = 3
    staleReplicaTimeout                                = 2880
    fromBackup                                         = ""
    encrypted                                          = true
    format                                             = "ext4"
    "csi.storage.k8s.io/provisioner-secret-name"       = "$${pvc.name}-longhorn"
    "csi.storage.k8s.io/provisioner-secret-namespace"  = "$${pvc.namespace}"
    "csi.storage.k8s.io/node-publish-secret-name"      = "$${pvc.name}-longhorn"
    "csi.storage.k8s.io/node-publish-secret-namespace" = "$${pvc.namespace}"
    "csi.storage.k8s.io/node-stage-secret-name"        = "$${pvc.name}-longhorn"
    "csi.storage.k8s.io/node-stage-secret-namespace"   = "$${pvc.namespace}"
  }
}

resource "kubernetes_storage_class_v1" "extras" {
  count = length(var.storage_classes)

  metadata {
    name = var.storage_classes[count.index].name
  }
  storage_provisioner    = "driver.longhorn.io"
  allow_volume_expansion = var.storage_classes[count.index].allow_volume_expansion
  reclaim_policy         = var.storage_classes[count.index].reclaim_policy
  parameters             = var.storage_classes[count.index].parameters
  mount_options          = var.storage_classes[count.index].mount_options
}
