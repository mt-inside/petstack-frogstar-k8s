module "bootstrap" {
  source = "../../../modules/bootstrap"

  deployment_name = "${var.deployment_name}"
}
