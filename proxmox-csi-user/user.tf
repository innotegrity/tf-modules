resource "proxmox_virtual_environment_role" "csi" {
  role_id = var.csi_role_name
  privileges = [
    "Sys.Audit",
    "VM.Audit",
    "VM.Config.Disk",
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.Audit"
  ]
}

resource "proxmox_virtual_environment_user" "this" {
  user_id  = var.csi_username
  password = var.csi_password
  comment  = "Managed by OpenTofu"

  acl {
    path      = "/"
    propagate = true
    role_id   = proxmox_virtual_environment_role.csi.role_id
  }
}

resource "proxmox_virtual_environment_user_token" "this" {
  comment               = "Managed by OpenTofu"
  token_name            = var.csi_token_name
  user_id               = proxmox_virtual_environment_user.this.user_id
  privileges_separation = false
}
