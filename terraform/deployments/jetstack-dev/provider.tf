# == AWS ==
provider "aws" {
  region = "${var.aws_az}"

  # Creds read from envioronment
}
