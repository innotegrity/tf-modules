output "file_id" {
  description = "The ID of the Talos image file."
  value       = proxmox_virtual_environment_download_file.this.id
}

output "file_name" {
  description = "The name of the Talos image file on the Proxmox server."
  value       = local.file_name
}

output "file_size" {
  description = "The size of the image file on the Proxmox server."
  value       = proxmox_virtual_environment_download_file.this.size
}

output "schematic_id" {
  description = "The generated ID/fingerprint of the schematic used when creating the image."
  value       = local.schematic_id
}

output "storage_pool" {
  description = "The storage pool in which the downloaded image file is stored."
  value       = var.storage_pool
}

output "source_urls" {
  description = "URLs to the source image."
  value       = data.talos_image_factory_urls.this.urls
}
