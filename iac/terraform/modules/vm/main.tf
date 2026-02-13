# ===========================================================================
# Module VM — Crée une VM Proxmox depuis un template cloud-init
# ===========================================================================

terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.name
  node_name = var.target_node

  clone {
    vm_id = var.template_id
    full  = true
  }

  cpu {
    cores   = var.cores
    sockets = var.sockets
    type    = "x86-64-v2-AES"
  }

  memory {
    dedicated = var.memory
    floating  = var.memory
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    size         = var.disk_size
    iothread     = true
    ssd          = true
  }

  network_device {
    bridge  = var.bridge
    vlan_id = var.vlan_tag
    model   = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = var.ip_address
        gateway = var.gateway
      }
    }
    dns {
      servers = var.dns_servers
      domain  = var.dns_domain
    }
    user_account {
      username = var.ci_user
      keys     = var.ssh_keys
    }
  }

  on_boot = var.start_on_boot

  tags = var.tags

  lifecycle {
    ignore_changes = [
      initialization[0].user_account,
    ]
  }
}
