# Private subnet for worker nodes
resource "oci_core_subnet" "private" {
  compartment_id             = var.compartment_id
  vcn_id                     = module.vcn.vcn_id
  cidr_block                 = var.private_subnet_cidr
  route_table_id             = module.vcn.nat_route_id
  display_name               = "${var.cluster_name}-private-subnet"
  prohibit_public_ip_on_vnic = true

  security_list_ids = [
    oci_core_security_list.private.id,
    oci_core_security_list.nlb_nodeport.id,
  ]
}

# Public subnet for K8s API endpoint and load balancers
resource "oci_core_subnet" "public" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = var.public_subnet_cidr
  route_table_id = module.vcn.ig_route_id
  display_name   = "${var.cluster_name}-public-subnet"

  security_list_ids = [oci_core_security_list.public.id]
}

# --- Security Lists ---

resource "oci_core_security_list" "private" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "${var.cluster_name}-private-sl"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  ingress_security_rules {
    stateless   = false
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }
}

resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "${var.cluster_name}-public-sl"

  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # Internal traffic
  ingress_security_rules {
    stateless   = false
    source      = var.vcn_cidr
    source_type = "CIDR_BLOCK"
    protocol    = "all"
  }

  # Kubernetes API
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 6443
      max = 6443
    }
  }

  # HTTP
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 80
      max = 80
    }
  }

  # HTTPS
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 443
      max = 443
    }
  }
}

# NLB NodePort range — required for Network Load Balancer health checks
# https://docs.oracle.com/en-us/iaas/Content/ContEng/Tasks/contengcreatingnetworkloadbalancers.htm
resource "oci_core_security_list" "nlb_nodeport" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "${var.cluster_name}-nlb-nodeport-sl"

  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 30000
      max = 32767
    }
  }
}
