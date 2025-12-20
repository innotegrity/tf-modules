locals {
  extensions = concat([
    "qemu-guest-agent",
    "iscsi-tools",
    "util-linux-tools",
  ], coalesce(var.extra_extensions, []))
  kernel_args = concat([
    "net.ifnames=0",
    "biosdevname=0"
  ], coalesce(var.extra_kernel_args, []))
  file_name    = "talos-${local.schematic_id}-${var.talos_version}-${basename(data.talos_image_factory_urls.this.urls.iso_secureboot)}"
  schematic_id = talos_image_factory_schematic.this.id
  platform     = "nocloud"
}
