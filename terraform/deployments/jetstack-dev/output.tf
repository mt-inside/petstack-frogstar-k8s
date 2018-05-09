output "server_instance_id" {
  value = "${module.test.instance_id}"
}

output "server_ssh" {
  value = "${module.test.ssh_conn_str}"
}
