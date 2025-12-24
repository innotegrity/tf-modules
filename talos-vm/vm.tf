resource "macaddress" "talos_node" {
  count = local.generate_random_mac ? 1 : 0

  prefix = var.dhcp.mac_address_prefix
}

resource "proxmox_virtual_environment_vm" "talos_node" {
  node_name = var.proxmox_node

  name        = var.hostname
  description = local.vm_description

  bios          = "ovmf"
  boot_order    = ["scsi0", "sata0"]
  machine       = "q35"
  on_boot       = true
  scsi_hardware = "virtio-scsi-single"
  tags          = local.vm_tags
  vm_id         = var.vm_id

  agent {
    enabled = true
  }

  cdrom {
    file_id   = var.talos_iso_file_id
    interface = "sata0"
  }

  cpu {
    cores = local.cpu_cores
    type  = "host"
  }


  disk {
    cache        = var.boot_disk.cache_mode
    datastore_id = var.boot_disk.storage_pool
    discard      = "on"
    file_format  = "raw"
    interface    = "scsi0"
    iothread     = true
    replicate    = false
    size         = local.disk_size
    ssd          = true
  }

  dynamic "disk" {
    for_each = var.extra_disks
    content {
      cache        = disk.value.cache_mode
      datastore_id = disk.value.storage_pool
      discard      = "on"
      file_format  = "raw"
      interface    = disk.key
      iothread     = true
      replicate    = false
      size         = disk.value.size
      ssd          = true
    }
  }

  efi_disk {
    datastore_id      = var.boot_disk.storage_pool
    file_format       = "raw"
    type              = "4m"
    pre_enrolled_keys = false
  }

  memory {
    dedicated = local.memory
    floating  = local.memory
  }

  network_device {
    bridge      = var.network_bridge
    mac_address = local.mac_address
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 6.X.
  }

  smbios {
    serial = "h=${var.proxmox_node};i=${var.vm_id}"
  }

  tpm_state {
    datastore_id = var.boot_disk.storage_pool
    version      = "v2.0"
  }

  vga {
    memory = 256
    type   = "virtio"
  }

  lifecycle {
    ignore_changes = [
      boot_order,
      cdrom,
      pool_id # deprecated but causes configuration drift issue if not here for now
    ]
  }
}

resource "proxmox_virtual_environment_pool_membership" "talos_node" {
  count = var.proxmox_pool != null ? 1 : 0

  vm_id   = proxmox_virtual_environment_vm.talos_node.id
  pool_id = var.proxmox_pool
}
