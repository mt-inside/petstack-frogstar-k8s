module "cluster" {
    source = "../../modules/cluster/gcloud"

    cluster_name = "${var.cluster_name}"
    gcloud_zone = "${var.gcloud_zone}"
    gcloud_billing_account = "${data.google_billing_account.billing_account.id}"
}
