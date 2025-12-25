variable "cluster_name" {
  type        = string
  description = "Name of the Talos cluster."
}

variable "client_configuration" {
  type = object({
    ca_certificate     = string
    client_certificate = string
    client_key         = string
  })
  description = "The Talos client configuration certificates and keys."
  sensitive   = true
}

variable "control_plane_nodes" {
  type        = list(string)
  description = "List of control plane IP addresses for the Talos cluster. Only when these nodes and the worker nodes return healthy will the module complete."
}

variable "endpoints" {
  type        = list(string)
  description = "List of endpoint IP addresses to use to check the cluster health."
}

variable "load_balancer_ip_blocks" {
  type = list(object({
    start = string
    stop  = string
  }))
  description = "A list of IP address ranges to allow LoadBalancer resources to use in the cluster."
}

variable "worker_nodes" {
  type        = list(string)
  description = "List of worker IP addresses for the Talos cluster. Only when these nodes and the control plane nodes return healthy will the module complete."
}
