module "bootstrap" {
  source = "../../../modules/bootstrap"

  deployment_name = "${var.deployment_name}"
}

resource "cloudflare_record" "mt165_co_uk_root" {
  domain  = "mt165.co.uk"
  name    = "@"
  type    = "A"
  value   = "${data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip}"
  ttl     = 120                                                                   # seems to be the shortest CF allows before overriding you to "default"
  proxied = false
}

resource "cloudflare_record" "mt165_co_uk_star" {
  domain  = "mt165.co.uk"
  name    = "*"
  type    = "A"
  value   = "${data.kubernetes_service.nginx_ingress.load_balancer_ingress.0.ip}"
  ttl     = 120                                                                   # seems to be the shortest CF allows before overriding you to "default"
  proxied = false
}
