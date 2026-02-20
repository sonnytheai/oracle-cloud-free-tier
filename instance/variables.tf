variable "compartment_id" {
  type        = string
  description = "Compartment OCID to create resources in"
}

variable "region" {
  type    = string
  default = "ap-chuncheon-1"
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for instance access"
}

variable "instance_name" {
  type    = string
  default = "free-arm-instance"
}

# Always Free maximum for A1.Flex
variable "ocpus" {
  type    = number
  default = 4
}

variable "memory_gbs" {
  type    = number
  default = 24
}

variable "boot_volume_size_gbs" {
  type        = number
  description = "Boot volume size in GB (Always Free max: 200 GB total)"
  default     = 200
}

# OS image — default to Oracle Linux 9 aarch64
variable "os_name" {
  type    = string
  default = "Oracle Linux"
}

variable "os_version" {
  type    = string
  default = "9"
}

# Networking
variable "vcn_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = string
  default = "10.0.0.0/24"
}
