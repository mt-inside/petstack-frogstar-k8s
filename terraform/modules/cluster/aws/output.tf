output "master_ids" {
  value = "${aws_instance.master.*.id}"
}

output "worker_ids" {
  value = "${aws_instance.worker.*.id}"
}

output "master_ssh_conn_str" {
  value = "ssh core@${aws_instance.master.*.public_ip[0]}"
}
