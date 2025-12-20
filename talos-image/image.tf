data "talos_image_factory_extensions_versions" "this" {
  talos_version = var.talos_version
  filters = {
    names = local.extensions
  }
}

data "talos_image_factory_urls" "this" {
  architecture  = var.arch
  platform      = local.platform
  schematic_id  = local.schematic_id
  talos_version = var.talos_version
}

resource "talos_image_factory_schematic" "this" {
  schematic = yamlencode({
    customization = {
      extraKernelArgs = local.kernel_args
      systemExtensions = {
        officialExtensions = data.talos_image_factory_extensions_versions.this.extensions_info.*.name
      }
    }
  })
}

resource "proxmox_virtual_environment_download_file" "this" {
  content_type = "iso"
  datastore_id = var.storage_pool
  node_name    = var.proxmox_node
  url          = data.talos_image_factory_urls.this.urls.iso_secureboot
  file_name    = local.file_name
}
