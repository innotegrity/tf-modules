<!-- omit in toc -->
# Proxmox CSI Driver Module

<!-- omit in toc -->
## Table of Contents

- [👁️ Overview](#️-overview)
- [✅ Provider Requirements](#-provider-requirements)
- [➡️ Inputs](#️-inputs)
- [⬅️ Outputs](#️-outputs)
- [📖 Custom Object Definitions](#-custom-object-definitions)
  - [StorageClassObject Type](#storageclassobject-type)

## 👁️ Overview

This module enables the CSI driver for Proxmox which automatically provisions and deprovisions volumes for the Kubernetes cluster using the Proxmox API.

## ✅ Provider Requirements

The following Terraform providers are required for this module:

- `hashicorp/helm` ~> 3.1
- `hashicorp/kubernetes` ~> 3.0

## ➡️ Inputs

The input variables for this module are defined below.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `csi_token_id` | `string` | The ID of the Proxmox token which is used by the CSI driver to (de)provision volumes |
| `csi_token_secret` | `string` | The corresponding secret value of the Proxmox token which is used by the CSI driver to (de)provision volumes |
| `proxmox_cluster` | `string` | The name of the Proxmox cluster |
| `proxmox_host` | `string` | The hostname of the Proxmox API server |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `namespace` | `string` | The name of the namespace to create for the CSI driver resources | `proxmox-csi` |
| `proxmox_port` | `number` | The port on which the Proxmox API is listening | `8006` |
| `proxmox_skip_verify_tls` | `bool` | Whether or not to skip the process of validating the certificate used by the Proxmox API server | `false` |
| `storage_classess` | `list(`[StorageClassObject](#storageclassobject-type)`)` | List of storage classes to create automatically during installation | `[]` |

## ⬅️ Outputs

This module produces no outputs.

## 📖 Custom Object Definitions

### StorageClassObject Type

This is an input object used to define the storage classes to automatically create upon installation of the CSI driver.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of storage class |
| `storage_pool` | `string` | The name of the storage device in Proxmox where volumes will be (de)provisioned |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `cache_mode` | `string` | The cache mode of the underlying disk ; must be `none`, `directsync`, `writeback` or `writethrough` | `none` |
| `fs_type` | `string` | The format of the filesystem to create ; must be `ext4` or `xfs` | `ext4` |
| `reclaim_policy` | `string` | The reclaim policy for the storage class ; must be `Delete` or `Retain` | `Delete` |
| `ssd` | `bool` | Whether or not to treat the volume as being on an SSD | `false` |
| `extra_parameters` | `map(string)` | Any additional parameters to pass to the storage class | `{}` |
| `mount_options` | `list(string)` | Any mount options to pass to the storage class | `[]` |
