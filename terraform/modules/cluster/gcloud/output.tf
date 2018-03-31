output "project_id" {
  value = "${google_project.project.project_id}"
}

output "cluster_version" {
  value = "${google_container_cluster.cluster.master_version}"
}

output "cluster_ip" {
  value = "${google_container_cluster.cluster.endpoint}"
}

output "client_key" {
  value = "${google_container_cluster.cluster.master_auth.0.client_key}" /* Used by clients to auth to the api server */
}

output "client_cert" {
  value = "${google_container_cluster.cluster.master_auth.0.client_certificate}" /* Used by clients to auth to the api server */
}

output "ca_cert" {
  value = "${google_container_cluster.cluster.master_auth.0.cluster_ca_certificate}" /* Cluster's CA cert */
}
