# Reserved public IP for ingress controller load balancer
resource "oci_core_public_ip" "ingress_lb" {
  compartment_id = var.compartment_id
  display_name   = "${var.cluster_name}-ingress-reserved-ip"
  lifetime       = "RESERVED"
}
