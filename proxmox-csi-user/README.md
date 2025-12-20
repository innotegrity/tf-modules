<!-- omit in toc -->
# Proxmox CSI User Module

<!-- omit in toc -->
## Table of Contents

- [👁️ Overview](#️-overview)
- [✅ Provider Requirements](#-provider-requirements)
- [➡️ Inputs](#️-inputs)
- [⬅️ Outputs](#️-outputs)

## 👁️ Overview

This module creates the necessary user and role used by the Proxmox CSI driver to automatically provision and deprovision storage volumes.

## ✅ Provider Requirements

The following Terraform providers are required for this module:

- `bpg/proxmox` ~> 0.89

## ➡️ Inputs

The input variables for this module are defined below.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `csi_password` | `string` | The pasword for the Proxmox user to create |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `csi_role_name` | `string` | The name of the role to create for the Proxmox CSI driver | `KubernetesCSI` |
| `csi_token_name` | `string` | The name of the token to generate for the Proxmox user | `csi` |
| `csi_username` | `string` | The name of the Proxmox user to create along with the domain (eg: `user@domain`) | `kubernetes-csi@pve` |

## ⬅️ Outputs

This module produces the following outputs:

| Variable | Type | Description |
| --- | --- | --- |
| `csi_token_id` | `string` | The ID of the token to use with the Proxmox CSI driver |
| `csi_token_secret` | `string` | The secret of the token to use with the Proxmox CSI driver |
