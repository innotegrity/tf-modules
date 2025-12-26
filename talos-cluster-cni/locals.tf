locals {
  gateway_crds_url      = "https://github.com/kubernetes-sigs/gateway-api/releases/download/v${var.gateway_crds_version}/${var.gateway_crds_experimental ? "experimental" : "standard"}-install.yaml"
  gateway_crds_manifest = yamldecode(data.http.gateway_crds.body)
}
