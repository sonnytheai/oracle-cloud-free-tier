# VCN
resource "oci_core_vcn" "this" {
  compartment_id = var.compartment_id
  cidr_blocks    = [var.vcn_cidr]
  display_name   = "${var.instance_name}-vcn"
  dns_label      = "armvcn"
}

# Internet Gateway
resource "oci_core_internet_gateway" "this" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.instance_name}-igw"
  enabled        = true
}

# Route Table
resource "oci_core_route_table" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.instance_name}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.this.id
  }
}

# Security List
resource "oci_core_security_list" "public" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.this.id
  display_name   = "${var.instance_name}-public-sl"

  # Egress: allow all
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }

  # SSH
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 22
      max = 22
    }
  }

  # ICMP (ping)
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
      code = 4
    }
  }

  # HTTP (optional — uncomment if needed)
  # ingress_security_rules {
  #   stateless   = false
  #   source      = "0.0.0.0/0"
  #   source_type = "CIDR_BLOCK"
  #   protocol    = "6"
  #   tcp_options {
  #     min = 80
  #     max = 80
  #   }
  # }

  # HTTPS (optional — uncomment if needed)
  # ingress_security_rules {
  #   stateless   = false
  #   source      = "0.0.0.0/0"
  #   source_type = "CIDR_BLOCK"
  #   protocol    = "6"
  #   tcp_options {
  #     min = 443
  #     max = 443
  #   }
  # }
}

# Public Subnet
resource "oci_core_subnet" "public" {
  compartment_id    = var.compartment_id
  vcn_id            = oci_core_vcn.this.id
  cidr_block        = var.subnet_cidr
  route_table_id    = oci_core_route_table.public.id
  security_list_ids = [oci_core_security_list.public.id]
  display_name      = "${var.instance_name}-public-subnet"
  dns_label         = "pubsub"
}
