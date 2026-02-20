# OCI Provider authentication
variable "tenancy_ocid" {
  type        = string
  description = "OCI Tenancy OCID"
}

variable "user_ocid" {
  type        = string
  description = "OCI User OCID"
}

variable "fingerprint" {
  type        = string
  description = "OCI API Key Fingerprint"
}

variable "private_key" {
  type        = string
  description = "OCI API Private Key content (PEM format)"
  sensitive   = true
}

variable "private_key_password" {
  type        = string
  description = "Password for encrypted private key (optional)"
  sensitive   = true
  default     = ""
}

provider "oci" {
  tenancy_ocid         = var.tenancy_ocid
  user_ocid            = var.user_ocid
  fingerprint          = var.fingerprint
  private_key          = var.private_key
  private_key_password = var.private_key_password != "" ? var.private_key_password : null
  region               = var.region
}
