data "ignition_config" "nginx" {
  systemd = [
    "${data.ignition_systemd_unit.nginx.id}",
  ]
}

data "ignition_systemd_unit" "nginx" {
  name = "nginx.service"

  content = "${file("${path.module}/userdata/files/nginx.service")}"
}
