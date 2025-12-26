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
  - [IPBlockObject Type](#ipblockobject-type)

## 👁️ Overview

This module installs and configures Cilium as the Talos Cluster CNI provider and enables its ingress and the Kubernetes Gateway APIs, allowing you to create Gateway resources in your k8s cluster.

## ✅ Provider Requirements

The following Terraform providers are required for this module:

- `hashicorp/helm` ~> 3.1
- `hashicorp/http` ~> 3.5
- `siderolabs/talos` ~> 0.9

## ➡️ Inputs

The input variables for this module are defined below.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `cluster_name` | `string` | The name used for the Talos cluster |
| `client_configuration` | [ClientConfigurationObject](#clientconfigurationobject-type) | Talos client configuration certificates and keys |
| `control_plane_nodes` | `list(string)` | List of control plane IP addresses for the Talos cluster. Only when these nodes and the worker nodes return healthy will the module complete. |
| `load_balancer_ip_blocks` | `list(`[IPBlockObject](#ipblockobject-type)`)` | A list of IP address blocks to use for `LoadBalancer` resources in the cluster |
| `endpoints` | `list(string)` | List of IP addresses to use to check the cluster health. |
| `worker_nodes` | `list(string)` | List of worker IP addresses for the Talos cluster. Only when these nodes and the control plane nodes return healthy will the module complete. |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `cilium_helm_version` | `string` | Version of the Helm chart to use to install Cilium CNI | `1.18.5` |
| `gateway_crds_experimental` | `bool` | Whether or not to install the experimental version of the Gateway CRDs | `true` |
| `gateway_crds_version` | `string` | Version of Gateway CRDs to install | `1.41` |

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

### IPBlockObject Type

This is an input object used to define the start and end ranges of IP blocks for load balancers.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `start` | `string` | The starting IP address of the block |
| `stop` | `string` | The ending IP address of the block |
