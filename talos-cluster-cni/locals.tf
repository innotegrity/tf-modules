locals {
  gateway_crds_url  = "https://github.com/kubernetes-sigs/gateway-api/releases/download/v${var.gateway_crds_version}/${var.gateway_crds_experimental ? "experimental" : "standard"}-install.yaml"
  gateway_crds_docs = split("---", data.http.gateway_crds.response_body)
  gateway_crds_decoded_docs = [
    for doc in local.gateway_crds_docs : try(yamldecode(doc), {})
  ]
  gateway_crds_manifests = [
    for doc in local.gateway_crds_decoded_docs : {
      for k, v in doc : k => v if k != "status"
    } if length(doc) > 0
  ]
}
