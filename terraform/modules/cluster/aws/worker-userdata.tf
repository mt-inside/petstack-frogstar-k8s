data "ignition_config" "worker" {
  append {
    source = "data:text/plain;base64,${base64encode(data.ignition_config.nginx.rendered)}"
  }

  files = [
    "${data.ignition_file.hostname_worker.id}",
  ]
}

data "ignition_file" "hostname_worker" {
  filesystem = "root"
  path       = "/etc/hostname"
  mode       = 0644

  content = {
    content = "worker"
  }
}
