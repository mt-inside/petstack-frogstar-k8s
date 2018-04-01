data "kubernetes_service" "nginx_ingress" {
  metadata {
    namespace = "ingress-nginx"
    name      = "ingress-nginx"
  }
}
