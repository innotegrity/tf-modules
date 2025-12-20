<!-- omit in toc -->
# Talos Linux Virtual Machine Module

<!-- omit in toc -->
## Table of Contents

- [👁️ Overview](#️-overview)
- [✅ Provider Requirements](#-provider-requirements)
- [➡️ Inputs](#️-inputs)
- [⬅️ Outputs](#️-outputs)
- [📖 Custom Object Definitions](#-custom-object-definitions)
  - [DHCPObject Type](#dhcpobject-type)
  - [DiskObject Type](#diskobject-type)

## 👁️ Overview

This module creates a virtual machine running Talos Linux booted from an ISO image.

You can optionally configure this module to reserve an IP address by using a DHCP reservation for the VM.

Supported backends for creating DHCP reservations are:

- Ubiquiti UDM Pro

## ✅ Provider Requirements

The following Terraform providers are required for this module:

- `ivoronin/macaddress` ~> v0.3
- `bpg/proxmox` ~> 0.89
- `ubiquiti-community/unifi` ~> 0.41

## ➡️ Inputs

The input variables for this module are defined below.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `hostname` | `string` | Name to use for the VM and for any DHCP reservations |
| `network_bridge` | `string` | The name of the network interface / bridge to use for the VM |
| `proxmox_node` | `string` | The name of the Proxmox node to use when deploying the VM |
| `storage_pool` | `string` | The name/ID of the storage device/pool in which to place the root disk |
| `talos_iso_file_id` | `string` | The ID of the Talos ISO image to use to deploy the VM |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `cluster_role` | `string` | The role of the node within the Talos cluster ; must be one of: `control-plane` or `worker` | `worker` |
| `cpu_cores` | `number` | The number of CPU cores to allocate to the VM | `4` for control plane nodes and `8` for worker nodes |
| `dhcp` | [DHCPObject](#dhcpobject-type) | DHCP reservation settings for the VM or `null` to disable DHCP reservation | `null` |
| `disk_cache_mode` | `string` | Cache mode of the root disk - must be one of the following: `none`,`directsync`, `writethrough`, `writeback`, or `unsafe` | `none` |
| `disk_size` | `number` | Size of the root disk in GB | `50` for control plane nodes and `100` for worker nodes |
| `extra_disks` | `map(`[DiskObject](#diskobject-type)`)` | Extra disks to add to the VM with the device name (eg: `scsi1` ) as the map key | `{}` |
| `memory` | `number` | The amount of memory (in GB) to allocate to the VM | `8` for control plane nodes and `32` for worker nodes |
| `proxmox_pool` | `string` | The name of the pool to add the Proxmox node to after it is created or `null` to not add it to any pool | `null` |
| `vm_id` | `number` | The unique ID to use for the VM or `null` to use the next available ID. | `null` |
| `vm_tags` | `list(string)` | List of tags to apply to the VM ; each VM is automatically tagged with its cluster role as well as `k8s` and `opentofu-managed` | `[]` |

## ⬅️ Outputs

This module produces the following outputs:

| Variable | Type | Description |
| --- | --- | --- |
| `mac_address` | `string` | MAC address of the main network interface |
| `vm_id` | `number` | ID of the newly created virtual machine |
| `vm_name` | `string` | Name of the newly created virtual machine |

## 📖 Custom Object Definitions

### DHCPObject Type

This is an input object used to define the configuration for a DHCP static reservation for the VM.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `ip_address` | `string` | The IP address to assign to the system via DHCP reservation |
| `provider` | `string` | The name of the DHCP provider to use ; must be `unifi` |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `mac_address` | `string` | The MAC address to assign to the system and set via DHCP reservation ; leave this `null` to generate a random MAC address instead | `null` |
| `mac_address_prefix` | `list(number)` | When generating a random MAC address, use these numbers to create its prefix | `[02, 01, 01]` |
| `reserve_hostname` | `bool` | Whether or not to also create a DNS hostname reservation for the IP address | `false` |

### DiskObject Type

This is an input object used to define the configuration for an extra disk to add to the VM.

**<u>Required Values</u>**

| Variable | Type | Description |
| --- | --- | --- |
| `size` | `number` | Size of the disk in GB |
| `storage_pool` | `string` | The name/ID of the storage device/pool in which to place the disk |

_<u>Optional Values</u>_

| Variable | Type | Description | Default |
| --- | --- | --- | --- |
| `cache_mode` | `string` | Cache mode of the disk - must be one of the following: `none`,`directsync`, `writethrough`, `writeback`, or `unsafe` | `none` |
