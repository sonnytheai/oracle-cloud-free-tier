# OKE Cluster
resource "oci_containerengine_cluster" "this" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.cluster_name
  vcn_id             = module.vcn.vcn_id

  endpoint_config {
    is_public_ip_enabled = true
    subnet_id            = oci_core_subnet.public.id
  }

  options {
    add_ons {
      is_kubernetes_dashboard_enabled = false
      is_tiller_enabled               = false
    }
    kubernetes_network_config {
      pods_cidr     = var.pods_cidr
      services_cidr = var.services_cidr
    }
    service_lb_subnet_ids = [oci_core_subnet.public.id]
  }
}

# Kubeconfig
data "oci_containerengine_cluster_kube_config" "this" {
  cluster_id = oci_containerengine_cluster.this.id
}

resource "local_file" "kubeconfig" {
  depends_on      = [oci_containerengine_node_pool.this]
  content         = data.oci_containerengine_cluster_kube_config.this.content
  filename        = "${path.module}/kubeconfig"
  file_permission = "0400"
}

# Node pool
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

data "oci_containerengine_node_pool_option" "opts" {
  node_pool_option_id = "all"
  compartment_id      = var.compartment_id
}

# Find the latest ARM OKE node image
data "jq_query" "latest_arm_image" {
  data  = jsonencode({ sources = jsondecode(jsonencode(data.oci_containerengine_node_pool_option.opts.sources)) })
  query = "[.sources[] | select(.source_name | test(\".*aarch.*OKE-${replace(var.kubernetes_version, "v", "")}.*\")?) .image_id][0]"
}

resource "oci_containerengine_node_pool" "this" {
  cluster_id         = oci_containerengine_cluster.this.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name               = var.node_pool_name

  node_metadata = {
    user_data = base64encode(file("${path.module}/files/node-init.sh"))
  }

  node_config_details {
    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id           = oci_core_subnet.private.id
    }
    size = var.worker_node_count
  }

  node_shape = "VM.Standard.A1.Flex"

  node_shape_config {
    memory_in_gbs = var.node_memory_gbs
    ocpus         = var.node_ocpus
  }

  node_source_details {
    image_id                = jsondecode(data.jq_query.latest_arm_image.result)
    source_type             = "image"
    boot_volume_size_in_gbs = var.boot_volume_size_gbs
  }

  initial_node_labels {
    key   = "name"
    value = var.cluster_name
  }

  ssh_public_key = var.ssh_public_key
}
