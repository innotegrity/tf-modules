<!-- omit in toc -->
# Talos Linux Cluster CNI Module

<!-- omit in toc -->
## Table of Contents

- [👁️ Overview](#️-overview)
- [✅ Provider Requirements](#-provider-requirements)
- [➡️ Inputs](#️-inputs)
- [⬅️ Outputs](#️-outputs)
- [📖 Custom Object Definitions](#-custom-object-definitions)
  - [ClientConfigurationObject Type](#clientconfigurationobject-type)

## 👁️ Overview

This module installs and configures Cilium as the Talos Cluster CNI provider.

## ✅ Provider Requirements

The following Terraform providers are required for this module:

- `hashicorp/helm` ~> 3.1
- `siderolabs/talos` ~> 0.9

## ➡️ Inputs

The input variables for this module are defined below.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `cluster_name` | `string` | The name used for the Talos cluster |
| `client_configuration` | [ClientConfigurationObject](#clientconfigurationobject-type) | Talos client configuration certificates and keys |
| `control_plane_nodes` | `list(string)` | List of control plane IP addresses for the Talos cluster. Only when these nodes and the worker nodes return healthy will the module complete. |
| `endpoints` | `list(string)` | List of IP addresses to use to check the cluster health. |
| `worker_nodes` | `list(string)` | List of worker IP addresses for the Talos cluster. Only when these nodes and the control plane nodes return healthy will the module complete. |

## ⬅️ Outputs

This module produces no outputs.

## 📖 Custom Object Definitions

### ClientConfigurationObject Type

This is an input object used to define the certificates and keys that must be used to connect to the Talos cluster.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `ca_certificate` | `string` | The CA certificate used to sign the client certificate |
| `client_certificate` | `string` | The client certificate used to connect to the Talos cluster |
| `client_key` | `string` | The client key used to connect to the Talos cluster |
