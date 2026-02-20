# OKE — Always Free Kubernetes Cluster

Managed Kubernetes (OKE) on Oracle Cloud Always Free tier ARM instances.

## Resource Allocation

| Resource | Per Node | Total (2 nodes) |
|----------|----------|-----------------|
| Shape | VM.Standard.A1.Flex | — |
| OCPUs | 2 | **4** |
| Memory | 12 GB | **24 GB** |
| Boot Volume | 50 GB | **100 GB** |

## What's Included

- VCN with public + private subnets, NAT/Internet/Service gateways
- OKE cluster with public API endpoint
- ARM node pool (2 nodes in private subnet)
- Reserved public IP for ingress controller
- NLB-compatible security lists (NodePort range)
- Kubeconfig auto-generated

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# Fill in your OCI credentials and compartment_id
terraform init
terraform plan
terraform apply

# Access the cluster
export KUBECONFIG=$(pwd)/kubeconfig
kubectl get nodes
```

## Ingress Controller Setup

Use the reserved IP with an NLB-based ingress controller:

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --set controller.service.type=LoadBalancer \
  --set controller.service.annotations."oci\.oraclecloud\.com/load-balancer-type"=nlb \
  --set controller.service.annotations."oci-network-load-balancer\.oraclecloud\.com/oci-reserved-public-ip"=$(terraform output -raw ingress_reserved_ip_ocid)
```

## Notes

- The free tier load balancer is **Network Load Balancer** (not flexible LB)
- Kubernetes version can be updated via `kubernetes_version` variable
- Node image is automatically selected (latest ARM OKE image)
