output "cluster_version" {
    value = "${google_container_cluster.cluster.master_version}"
}

output "cluster_ip" {
    value = "${google_container_cluster.cluster.endpoint}"
}

output "client_key" { /* Used by clients to auth to the api server */
    value = "${google_container_cluster.cluster.master_auth.0.client_key}"
}

output "client_cert" { /* Used by clients to auth to the api server */
    value = "${google_container_cluster.cluster.master_auth.0.client_certificate}"
}

output "ca_cert" { /* Cluster's CA cert */
    value = "${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}"
}
