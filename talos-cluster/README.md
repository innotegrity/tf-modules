<!-- omit in toc -->
# Talos Linux Cluster Module

<!-- omit in toc -->
## Table of Contents

- [👁️ Overview](#️-overview)
- [✅ Provider Requirements](#-provider-requirements)
- [➡️ Inputs](#️-inputs)
- [⬅️ Outputs](#️-outputs)
- [📖 Custom Object Definitions](#-custom-object-definitions)
  - [DNSObject Type](#dnsobject-type)
  - [KubernetesConfigObject Type](#kubernetesconfigobject-type)
  - [NodeObject Type](#nodeobject-type)
  - [OIDCConfigObject Type](#oidcconfigobject-type)

## 👁️ Overview

This module creates, configures and bootstraps a Talos cluster which will be ready to run Cilium as the CNI provider.

You **must** run the [Talos Linux Cluster CNI Module](../talos-cluster-cni/README.md) **after** this module in order to have a functioning cluster.

You can optionally register any cluster SANs with DNS using any of the following providers:

- Ubiquiti UDM Pro

## ✅ Provider Requirements

The following Terraform providers are required for this module:

- `hashicorp/null` ~> 3.2
- `siderolabs/talos` ~> 0.9
- `ubiquiti-community/unifi` ~> 0.41

## ➡️ Inputs

The input variables for this module are defined below.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `cluster_name` | `string` | The name to use for the Talos cluster |
| `control_plane_nodes` | `map(`[NodeObject](#nodeobject-type)`)` | Configuration for control plane nodes |
| `k8s_version` | `string` | The Kubernetes version to use for the cluster ; must be one of the official <a href="https://kubernetes.io/releases/" target="_blank">Kubernetes release versions</a> |
| `talos_installer_image_id` | `string` | The ID of the Talos installer image to use when installing the containers onto the cluster VMs ; this should be the `installer_secureboot` value from the `source_urls` output in the [Talos ISO Image Module](../talos-image/README.md) |
| `talos_version` | `string` | The version of Talos to use for the generated node configurations |
| `worker_nodes` | `map(`[NodeObject](#nodeobject-type)`)` | Configuration for worker nodes |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `cluster_sans` | `list(string)` | A list of additional hostnames or IPs to add to the API server SSL certificate in addition to the default hostnames and IPs | `[]` |
| `cluster_vip` | `string` | Virtual IP to use for the main cluster endpoint; if `null` then no VIP is allocated | `null` |
| `dns` | [DNSObject](#dnsobject-type) | DNS configuration for registering cluster SANs to the `cluster_vip` or `null` to disable DNS registration ; if `cluster_vip` is not provided or `cluster_sans` is empty then this value is ignored | `null` |
| `oidc_config` | [OIDCConfigObject](#oidcconfigobject-type) | OIDC configuration for authentication or `null` to disable OIDC authentication | `null` |

## ⬅️ Outputs

This module produces the following outputs:

| Variable | Type | Description |
| --- | --- | --- |
| `talos_config_file_contents` | `string` | The contents to add to the `talosctl` configuration file |
| `talos_machine_secrets` | `object` | Secrets used by the Talos cluster (see the [talos_machine_secrets Resource](https://registry.terraform.io/providers/siderolabs/talos/latest/docs/resources/machine_secrets) |
| `kubeconfig_file_contents` | `string` | The contents to add to the `kubectl` configuration file |
| `kubeconfig` | [KubernetesConfigObject](#kubernetesconfigobject-type) | Kubernetes cluster configuration |

## 📖 Custom Object Definitions

### DNSObject Type

This is an input object used to define the configuration for automatic cluster SAN name to cluster VIP registration in DNS.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `provider` | `string` | The name of the DHCP provider to use ; must be `unifi` |

### KubernetesConfigObject Type

This is an output object that contains the configuration for the Kubernetes cluster created by the module.

| Variable | Type | Description |
| --- | --- | --- |
| `ca_certificate` | `string` | The CA certificate for the Kubernetes cluster |
| `client_certificate` | `string` | The client certificate for the Kubernetes cluster |
| `client_key` | `string` | The client key for the Kubernetes cluster |
| `host` | `string` | The hostname or IP address of the Kubernetes cluster |

### NodeObject Type

This is an input object used to define the configuration settings for a cluster node.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `hostname` | `string` | The hostname for the node |
| `ip_address` | `string` | The IP address for the node |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `annotations` | `map(string)` | Extra annotations to add to the cluster node | `{}` |
| `enable_longhorn` | `bool` | If Longhorn was enabled when creating the VM, set this to `true` to automatically provision and configure the storage for Longhorn on the node | `false` |
| `labels` | `map(string)` | Extra labels to add to the cluster node | `{}` |

### OIDCConfigObject Type

This is an input object used to define the configuration for the OIDC authentication provider for the Kubernetes cluster.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `issuer_url` | `string` | The URL of the OIDC issuer |
| `client_id` | `string` | The ID of the OIDC client |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `username_claim` | `string` | The attribute containing the username | `email` |
| `groups_claim` | `string` | The attribute containing the groups | `groups` |
| `groups_prefix` | `string` | Prefix to use for any groups returned from the OIDC provider so they can be distinguished from built-in cluster groups | `oidc:` |
