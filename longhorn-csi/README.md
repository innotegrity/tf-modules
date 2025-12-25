<!-- omit in toc -->
# Longhorn CSI Driver Module

<!-- omit in toc -->
## Table of Contents

- [👁️ Overview](#️-overview)
- [✅ Provider Requirements](#-provider-requirements)
- [➡️ Inputs](#️-inputs)
- [⬅️ Outputs](#️-outputs)
- [📖 Custom Object Definitions](#-custom-object-definitions)
  - [StorageClassObject Type](#storageclassobject-type)

## 👁️ Overview

This module installs Longhorn for creating volumes in the Talos cluster and will automatically create the following storage classes:

- `longhorn-ext4`: a basic volume formatted using ext4
- `longhorn-ext4-retain`: a basic volume formatted using ext4 with a reclaim policy of `Retain`
- `longhorn-ext4-encrypted`: an encrypted volume formatted using ext4
- `longhorn-ext4-encrypted-retain`: an encrypted volume formatted using ext4 with a reclaim policy of `Retain`

## ✅ Provider Requirements

The following Terraform providers are required for this module:

- `hashicorp/helm` ~> 3.1
- `hashicorp/kubernetes` ~> 3.0

## ➡️ Inputs

The input variables for this module are defined below.

**<u>Required Values</u>**

There are no required values for this module.

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `namespace` | `string` | The name of the namespace to create for the CSI driver resources | `longhorn-system` |
| `storage_classess` | `list(`[StorageClassObject](#storageclassobject-type)`)` | List of additional storage classes to create automatically during installation | `[]` |

## ⬅️ Outputs

This module produces no outputs.

## 📖 Custom Object Definitions

### StorageClassObject Type

This is an input object used to define the storage classes to automatically create upon installation of the CSI driver.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of storage class |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `allow_volume_expansion` | `bool` | Allow volumes to be expanded | `true` |
| `reclaim_policy` | `string` | The reclaim policy for the storage class ; must be `Delete` or `Retain` | `Delete` |
| `parameters` | `map(string)` | Parameters to pass to the storage class | `{}` |
| `mount_options` | `list(string)` | Mount options to pass to the storage class | `[]` |
