# == Vault ==
provider "vault" {
  address = "http://sun:8200"
}

# == Kubernetes ==
# - i.e. the cluster we just made
# Kubernetes is used in two ways
# - The official provider
# - null_resources that call kubectl
# Currently, both just use the current context in the user's kubeconfig
# file. This could be better, qv README

# == Github ==
variable "github_org" {
  default = "mt-inside"
}

data "vault_generic_secret" "github" {
  path = "infra/generic/github/mt-inside"
}

provider "github" {
  organization = "${var.github_org}"
  token        = "${data.vault_generic_secret.github.data["api-token"]}"
}

# == Cloudflare ==
variable "cloudflare_id" {
  default = "matturner@gmail.com"
}

data "vault_generic_secret" "cloudflare" {
  path = "infra/generic/cloudflare/matturner"
}

provider "cloudflare" {
  email = "${var.cloudflare_id}"
  token = "${data.vault_generic_secret.cloudflare.data["api-token"]}"
}
