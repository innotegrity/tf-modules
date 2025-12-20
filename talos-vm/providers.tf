terraform {
  required_providers {
    macaddress = {
      source  = "ivoronin/macaddress"
      version = "~> 0.3"
    }

    /*
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.89"
    }
*/
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }

    unifi = {
      source  = "ubiquiti-community/unifi"
      version = "~> 0.41"
    }
  }
}
