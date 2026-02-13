# ===========================================================================
# Module Cloud-Init — Outputs
# ===========================================================================

output "file_id" {
  description = "ID du fichier snippet dans Proxmox"
  value       = proxmox_virtual_environment_file.cloud_config.id
}
