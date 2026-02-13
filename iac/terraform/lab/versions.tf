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

  # Authentification via variables d'environnement :
  #   PM_API_TOKEN_ID     = "terraform@pam!iac"
  #   PM_API_TOKEN_SECRET = "xxxxx"
  # ou
  #   PM_USER = "root@pam"
  #   PM_PASS = "xxxxx"
}
