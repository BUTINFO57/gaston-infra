# ===========================================================================
# Module Network — Outputs
# ===========================================================================

output "bridge_names" {
  description = "Noms des bridges créés"
  value       = [for b in proxmox_virtual_environment_network_linux_bridge.bridge : b.name]
}
