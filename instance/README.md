# Instance — Always Free ARM VM

Single ARM instance using the full Oracle Cloud Always Free allocation.

## Resource Allocation

| Resource | Value |
|----------|-------|
| Shape | VM.Standard.A1.Flex |
| OCPUs | **4** |
| Memory | **24 GB** |
| Boot Volume | **200 GB** |
| OS | Oracle Linux 9 (aarch64) |

## What's Included

- VCN with public subnet and internet gateway
- ARM instance with public IP
- Security list (SSH + ICMP enabled, HTTP/HTTPS commented out)
- Cloud-init: auto-expands boot volume, installs common tools

## Usage

```bash
cp terraform.tfvars.example terraform.tfvars
# Fill in your OCI credentials and compartment_id
terraform init
terraform plan
terraform apply

# SSH into the instance
$(terraform output -raw ssh_command)
```

## Opening Additional Ports

Uncomment the HTTP/HTTPS rules in `networking.tf`, then:

```bash
terraform apply
```

Also open ports in the instance's OS firewall:

```bash
sudo iptables -I INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 443 -j ACCEPT
sudo netfilter-persistent save
```

## Notes

- Default user is `opc` (Oracle Linux) or `ubuntu` (Ubuntu)
- Boot volume auto-expands to full size via cloud-init
- This uses the **entire** A1 free allocation — cannot run alongside the OKE template
