output "instance_id" {
  value = oci_core_instance.this.id
}

output "public_ip" {
  value = oci_core_instance.this.public_ip
}

output "private_ip" {
  value = oci_core_instance.this.private_ip
}

output "ssh_command" {
  value = "ssh opc@${oci_core_instance.this.public_ip}"
}
