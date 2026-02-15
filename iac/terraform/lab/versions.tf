# ===========================================================================
# LAB — Contraintes de version
# ===========================================================================

terraform {
  required_version = ">= 1.6"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.50"
    }
  }
}

provider "proxmox" {
  endpoint = var.pm_api_url
  insecure = true

  # Authentification via variables d'environnement (provider bpg/proxmox) :
  #   PROXMOX_VE_API_TOKEN = "terraform@pam!iac=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  # ou :
  #   PROXMOX_VE_USERNAME = "root@pam"
  #   PROXMOX_VE_PASSWORD = "xxxxx"
}
