module "test" {
  source = "../../modules/cluster/aws"

  deployment_name = "${var.deployment_name}"
  aws_az          = "${var.aws_az}"
}
