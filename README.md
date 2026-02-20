# Oracle Cloud Always Free Tier — Terraform Templates

Ready-to-use Terraform templates that maximize Oracle Cloud's **Always Free** ARM resources.

## Always Free ARM Limits

| Resource | Limit |
|----------|-------|
| Ampere A1 OCPUs | **4 OCPUs** |
| Ampere A1 Memory | **24 GB** |
| Boot Volume | **200 GB** total (2× 47.6 GB default + extra) |
| Block Volume | **200 GB** total |
| Object Storage | **20 GB** |
| Load Balancer | **1 flexible** (10 Mbps) |
| Reserved Public IPs | **1** |

> These limits are shared across all A1 instances in your tenancy.

## Templates

| Directory | Description |
|-----------|-------------|
| [`oke/`](./oke/) | OKE (managed Kubernetes) cluster — 2 ARM nodes (2 OCPU / 12 GB each) |
| [`instance/`](./instance/) | Single ARM VM — 4 OCPU / 24 GB / 200 GB boot volume |

Choose **one** — you cannot run both simultaneously within the free tier.

## ⚠️ Important: Upgrade to Pay-As-You-Go

Oracle Cloud **trial accounts** (30-day free trial) have strict resource limits and will be **terminated after 30 days**, deleting all resources.

To actually provision Always Free ARM instances, you must **upgrade to a Pay-As-You-Go (PAYG) account**:

- Go to **OCI Console → Billing → Upgrade and Manage Payment**
- Add a credit card (you won't be charged for Always Free resources)
- After upgrade, Always Free resources persist **indefinitely**

Without upgrading, you **cannot create Ampere A1 instances at all** — OCI will reject the provisioning request.

## Prerequisites

1. [Oracle Cloud account](https://cloud.oracle.com/) upgraded to **Pay-As-You-Go** (see above)
2. [Terraform](https://developer.hashicorp.com/terraform/install) ≥ 1.3
3. OCI API key configured:
   - `tenancy_ocid`
   - `user_ocid`
   - `fingerprint`
   - `private_key` (PEM content)
   - `compartment_id`

### Generate an API Key

```bash
# Via OCI CLI
oci setup config

# Or manually in OCI Console:
# Profile → API Keys → Add API Key
```

## Quick Start

```bash
cd oke/   # or instance/
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
terraform init
terraform plan
terraform apply
```

## Default Region

All templates default to **ap-chuncheon-1** (Chuncheon, South Korea). Override via `region` variable.

## License

MIT
