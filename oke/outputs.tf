output "cluster_id" {
  value = oci_containerengine_cluster.this.id
}

output "node_pool_id" {
  value = oci_containerengine_node_pool.this.id
}

output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}

output "ingress_reserved_ip" {
  value       = oci_core_public_ip.ingress_lb.ip_address
  description = "Reserved public IP for ingress controller LoadBalancer"
}

output "ingress_reserved_ip_ocid" {
  value       = oci_core_public_ip.ingress_lb.id
  description = "OCID of the reserved IP (use in K8s Service annotations)"
}
