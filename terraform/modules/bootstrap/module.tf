module "helm-rbac" {
  source   = "./kubernetes_manifest"
  manifest = "${file("${path.module}/manifests/helm/rbac.yaml")}"
}

resource "null_resource" "helm-install" {
  triggers {
    helm_rbac = "${module.helm-rbac.done}"
  }

  provisioner "local-exec" {
    command = "helm init --service-account tiller"
  }

  provisioner "local-exec" {
    command = "helm reset -f"
    when    = "destroy"
  }
}

/* == FLUX == */

# Make keypair.
# TODO: only seems to support bad curves
# TODO: no option for comments
# TODO: want: ssh-keygen -t ed25519 -N "" -C "Flux keypair for frogstar-b"
resource "tls_private_key" "github" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Upload key
resource "github_repository_deploy_key" "flux" {
  title      = "Flux keypair for ${var.deployment_name}"
  repository = "petstack-frogstar-k8s"
  key        = "${tls_private_key.github.public_key_openssh}"
  read_only  = "false"                                        // Needs RW access to the repo to push tags
}

resource "kubernetes_secret" "flux-git-key" {
  metadata {
    namespace = "default"
    name      = "flux-git-deploy"
  }

  type = "generic"

  data {
    identity = "${tls_private_key.github.private_key_pem}"
  }
}

/* TODO: make this module iterate over an array */
module "flux-rbac" {
  source   = "./kubernetes_manifest"
  manifest = "${file("${path.module}/manifests/flux/flux-account.yaml")}"
}

module "flux-dep" {
  source   = "./kubernetes_manifest"
  manifest = "${file("${path.module}/manifests/flux/flux-deployment.yaml")}"
}

module "flux-helm-dep" {
  source   = "./kubernetes_manifest"
  manifest = "${file("${path.module}/manifests/flux/helm-operator-deployment.yaml")}"
}

module "flux-helm-crd" {
  source   = "./kubernetes_manifest"
  manifest = "${file("${path.module}/manifests/flux/flux-helm-release-crd.yaml")}"
}

/* Not using:
* - Github secret (making our own)
* - memcache dep (optional, need the space)
* - memcache svc (optional, need the space)
* - service (not using fluxctl for now)
*/

