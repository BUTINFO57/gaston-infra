# ===========================================================================
# Module Network — Gère les bridges et VLANs sur un nœud Proxmox
# ===========================================================================

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_network_linux_bridge" "bridge" {
  for_each = var.bridges

  node_name = var.node_name
  name      = each.key
  comment   = each.value.comment

  autostart = true
}
