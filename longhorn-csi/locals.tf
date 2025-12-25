locals {
  helm_values = {
    defaultSettings = {
      defaultReplicaCount                     = 1
      storageReservedPercentageForDefaultDisk = 1
      defaultDataPath                         = "/var/mnt/longhorn"
    }
    persistence = {
      defaultClass = false
    }
  }
}
