terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }

    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.89"
    }
  }
}
