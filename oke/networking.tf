module "vcn" {
  source                       = "oracle-terraform-modules/vcn/oci"
  version                      = "3.6.0"
  compartment_id               = var.compartment_id
  region                       = var.region
  internet_gateway_route_rules = null
  local_peering_gateways       = null
  nat_gateway_route_rules      = null
  vcn_name                     = var.vcn_name
  vcn_dns_label                = var.vcn_dns_label
  vcn_cidrs                    = [var.vcn_cidr]
  create_internet_gateway      = true
  create_nat_gateway           = true
  create_service_gateway       = true
}
