# ===========================================================================
# Module VM — Outputs
# ===========================================================================

output "vm_id" {
  description = "VMID Proxmox de la VM créée"
  value       = proxmox_virtual_environment_vm.vm.vm_id
}

output "vm_name" {
  description = "Nom de la VM"
  value       = proxmox_virtual_environment_vm.vm.name
}

output "ipv4_address" {
  description = "Adresse IPv4 de la VM"
  value       = var.ip_address
}

output "node_name" {
  description = "Nœud Proxmox hébergeant la VM"
  value       = proxmox_virtual_environment_vm.vm.node_name
}
