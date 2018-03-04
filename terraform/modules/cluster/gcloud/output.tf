output "cluster_version" {
    value = "${google_container_cluster.cluster.master_version}"
}

output "cluster_ip" {
    value = "${google_container_cluster.cluster.endpoint}"
}
