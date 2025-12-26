terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.1"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 3.5"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.9"
    }
  }
}
