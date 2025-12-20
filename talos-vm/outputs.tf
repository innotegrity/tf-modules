output "vm_id" {
  description = "The ID of the newly created virtual machine."
  value       = proxmox_virtual_environment_vm.talos_node.id
}

output "vm_name" {
  description = "The name of the new created virtual machine."
  value       = proxmox_virtual_environment_vm.talos_node.name
}

output "mac_address" {
  description = "The MAC address of the virtual machine."
  value       = proxmox_virtual_environment_vm.talos_node.mac_addresses[0]
}
