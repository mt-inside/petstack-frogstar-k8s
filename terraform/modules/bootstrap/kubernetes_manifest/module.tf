# Or, use: https://github.com/ericchiang/terraform-provider-k8s

resource "null_resource" "kubernetes_manifest" {
  triggers {
    manifest = "${var.manifest}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f - <<EOF\n${var.manifest}\nEOF"

    # TODO: should do auth properly, see readme
    #command = "kubectl --certificate-authority=<(echo '${module.cluster.ca_cert}') --client-certificate=<(echo '${module.cluster.client_cert}') --client-key=<(echo '${module.cluster.client_key}') apply -f - <<EOF\n${var.manifest}\nEOF"
  }

  provisioner "local-exec" {
    command = "kubectl delete -f - <<EOF\n${var.manifest}\nEOF"
    when    = "destroy"
  }
}
