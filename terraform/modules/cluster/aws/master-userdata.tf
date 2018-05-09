data "ignition_config" "master" {
  append {
    source = "data:text/plain;base64,${base64encode(data.ignition_config.nginx.rendered)}"
  }

  files = [
    "${data.ignition_file.hostname_master.id}",
  ]
}

data "ignition_file" "hostname_master" {
  filesystem = "root"
  path       = "/etc/hostname"
  mode       = 0644

  content = {
    content = "master"
  }
}
