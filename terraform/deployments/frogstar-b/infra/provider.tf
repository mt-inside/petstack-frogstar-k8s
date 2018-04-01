# == Vault ==
provider "vault" {
  address = "http://sun:8200"
}

# == GCloud ==
# No config for now; just do "gcloud auth app-defaults login"

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
