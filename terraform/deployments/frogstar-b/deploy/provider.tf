# Kubernetes
# Kubernetes is used in two ways
# - The official provider
# - null_resources that call kubectl
# Currently, both just use the current context in the user's kubeconfig
# file. This could be better, qv README

# github
variable "github_org" {
  default = "mt-inside"
}

variable "github_token" {
  # github_token comes from the cmdline, should be vault
}

provider "github" {
  organization = "${var.github_org}"
  token        = "${var.github_token}"
}
