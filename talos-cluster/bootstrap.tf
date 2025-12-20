resource "talos_machine_bootstrap" "this" {
  depends_on = [
    talos_machine_configuration_apply.control_plane,
    talos_machine_configuration_apply.worker
  ]

  node                 = local.endpoint_ips[0]
  client_configuration = talos_machine_secrets.this.client_configuration
}

resource "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on = [
    talos_machine_bootstrap.this
  ]

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = local.endpoint_ips[0]
}

resource "null_resource" "wait_for_k8s_api" {
  depends_on = [
    talos_cluster_kubeconfig.kubeconfig
  ]
  triggers = {
    kubeconfig_content_hash = md5(talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw)
  }

  provisioner "local-exec" {
    command = <<-EOT
      filename=$(mktemp)
      echo "${talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw}" > $filename
      export KUBECONFIG=$filename
      until kubectl get nodes > /dev/null 2>&1; do
        echo "Waiting for Kubernetes API to be ready..."
        sleep 5
      done
      echo "Kubernetes API is ready."
      rm -f $filename
    EOT
  }
}
