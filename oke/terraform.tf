terraform {
  # Local backend (default)
  # backend "local" {}

  # Optional: S3-compatible backend (OCI Object Storage)
  # backend "s3" {
  #   bucket                      = "terraform-states"
  #   key                         = "oke/terraform.tfstate"
  #   endpoint                    = "https://<namespace>.compat.objectstorage.<region>.oraclecloud.com"
  #   region                      = "ap-chuncheon-1"
  #   shared_credentials_file     = "~/.oci/config"
  #   skip_region_validation      = true
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   force_path_style            = true
  # }

  required_providers {
    jq = {
      source  = "massdriver-cloud/jq"
      version = "0.2.1"
    }
    oci = {
      source  = "oracle/oci"
      version = "~> 7.2.0"
    }
  }
}
