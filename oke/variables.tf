variable "compartment_id" {
  type        = string
  description = "Compartment OCID to create resources in"
}

variable "region" {
  type        = string
  description = "OCI region"
  default     = "ap-chuncheon-1"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for node access"
}

# Kubernetes
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version (https://docs.oracle.com/en-us/iaas/Content/ContEng/Concepts/contengaboutk8sversions.htm)"
  default     = "v1.34.1"
}

variable "worker_node_count" {
  type        = number
  description = "Number of worker nodes"
  default     = 2
}

# VCN
variable "vcn_name" {
  type    = string
  default = "oke-vcn"
}

variable "vcn_dns_label" {
  type    = string
  default = "okevcn"
}

variable "vcn_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

# Subnets
variable "private_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}

# Cluster
variable "cluster_name" {
  type    = string
  default = "free-oke-cluster"
}

variable "node_pool_name" {
  type    = string
  default = "free-arm-node-pool"
}

# Node sizing — Always Free maximum: 4 OCPU / 24 GB split across nodes
variable "node_ocpus" {
  type        = number
  description = "OCPUs per node (total across all nodes must not exceed 4)"
  default     = 2
}

variable "node_memory_gbs" {
  type        = number
  description = "Memory (GB) per node (total across all nodes must not exceed 24)"
  default     = 12
}

variable "boot_volume_size_gbs" {
  type        = number
  description = "Boot volume size (GB) per node"
  default     = 50
}

# Kubernetes networking
variable "pods_cidr" {
  type    = string
  default = "10.244.0.0/16"
}

variable "services_cidr" {
  type    = string
  default = "10.96.0.0/16"
}
