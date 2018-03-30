variable "cluster_admin_user" {
  default = "matturner@gmail.com"
}

variable "gcloud_zone" {
  default = "europe-west2-a"
}

module "cluster" {
  source = "../../../modules/cluster/gcloud"

  deployment_name        = "${var.deployment_name}"
  gcloud_zone            = "${var.gcloud_zone}"
  gcloud_billing_account = "${data.google_billing_account.billing_account.id}"
  cluster_admin_user     = "${var.cluster_admin_user}"
}
