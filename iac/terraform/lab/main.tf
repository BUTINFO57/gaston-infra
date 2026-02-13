# ===========================================================================
# LAB — Provisioning mono-hôte Proxmox
# Toutes les VMs sur un seul nœud, VLANs via tags sur vmbr0
# Réf. : docs/lab/overview.md · docs/architecture/ip-plan.md
# ===========================================================================

# -------------------------------------------------------------------------
# VLAN 10 — Admin / Infra
# -------------------------------------------------------------------------

module "ad_dc01" {
  source      = "../modules/vm"
  name        = "ad-dc01"
  target_node = var.pm_node
  template_id = var.template_id_debian
  cores       = 2
  memory      = 2048
  disk_size   = 32
  storage     = var.storage
  bridge      = var.bridge
  vlan_tag    = 10
  ip_address  = "${var.vlan10_prefix}.10/24"
  gateway     = "${var.vlan10_prefix}.1"
  dns_servers = var.dns_servers
  ssh_keys    = var.ssh_public_keys
  tags        = ["iac", "ad", "vlan10"]
}

module "ad_dc02" {
  source      = "../modules/vm"
  name        = "ad-dc02"
  target_node = var.pm_node
  template_id = var.template_id_debian
  cores       = 2
  memory      = 2048
  disk_size   = 32
  storage     = var.storage
  bridge      = var.bridge
  vlan_tag    = 10
  ip_address  = "${var.vlan10_prefix}.9/24"
  gateway     = "${var.vlan10_prefix}.1"
  dns_servers = var.dns_servers
  ssh_keys    = var.ssh_public_keys
  tags        = ["iac", "ad", "vlan10"]
}

module "mon_01" {
  source      = "../modules/vm"
  name        = "mon-01"
  target_node = var.pm_node
  template_id = var.template_id_debian
  cores       = 2
  memory      = 2048
  disk_size   = 32
  storage     = var.storage
  bridge      = var.bridge
  vlan_tag    = 10
  ip_address  = "${var.vlan10_prefix}.114/24"
  gateway     = "${var.vlan10_prefix}.1"
  dns_servers = var.dns_servers
  ssh_keys    = var.ssh_public_keys
  tags        = ["iac", "monitoring", "vlan10"]
}

module "mail_01" {
  source      = "../modules/vm"
  name        = "mail-01"
  target_node = var.pm_node
  template_id = var.template_id_debian
  cores       = 2
  memory      = 4096
  disk_size   = 64
  storage     = var.storage
  bridge      = var.bridge
  vlan_tag    = 10
  ip_address  = "${var.vlan10_prefix}.115/24"
  gateway     = "${var.vlan10_prefix}.1"
  dns_servers = var.dns_servers
  ssh_keys    = var.ssh_public_keys
  tags        = ["iac", "mail", "vlan10"]
}

# -------------------------------------------------------------------------
# VLAN 20 — Production (Web 3-tiers)
# -------------------------------------------------------------------------

module "rp_prod01" {
  source      = "../modules/vm"
  name        = "rp-prod01"
  target_node = var.pm_node
  template_id = var.template_id_debian
  cores       = 2
  memory      = 1024
  disk_size   = 16
  storage     = var.storage
  bridge      = var.bridge
  vlan_tag    = 20
  ip_address  = "${var.vlan20_prefix}.106/24"
  gateway     = "${var.vlan20_prefix}.1"
  dns_servers = var.dns_servers
  ssh_keys    = var.ssh_public_keys
  tags        = ["iac", "web", "vlan20"]
}

module "web_wp01" {
  source      = "../modules/vm"
  name        = "web-wp01"
  target_node = var.pm_node
  template_id = var.template_id_debian
  cores       = 2
  memory      = 2048
  disk_size   = 32
  storage     = var.storage
  bridge      = var.bridge
  vlan_tag    = 20
  ip_address  = "${var.vlan20_prefix}.108/24"
  gateway     = "${var.vlan20_prefix}.1"
  dns_servers = var.dns_servers
  ssh_keys    = var.ssh_public_keys
  tags        = ["iac", "web", "vlan20"]
}

module "maria_prod01" {
  source      = "../modules/vm"
  name        = "maria-prod01"
  target_node = var.pm_node
  template_id = var.template_id_debian
  cores       = 2
  memory      = 2048
  disk_size   = 32
  storage     = var.storage
  bridge      = var.bridge
  vlan_tag    = 20
  ip_address  = "${var.vlan20_prefix}.105/24"
  gateway     = "${var.vlan20_prefix}.1"
  dns_servers = var.dns_servers
  ssh_keys    = var.ssh_public_keys
  tags        = ["iac", "db", "vlan20"]
}

# -------------------------------------------------------------------------
# VLAN 30 — Backup
# -------------------------------------------------------------------------

module "pbs" {
  source      = "../modules/vm"
  name        = "pbs"
  target_node = var.pm_node
  template_id = var.template_id_debian
  cores       = 2
  memory      = 2048
  disk_size   = 128
  storage     = var.storage
  bridge      = var.bridge
  vlan_tag    = 30
  ip_address  = "${var.vlan30_prefix}.100/24"
  gateway     = "${var.vlan30_prefix}.1"
  dns_servers = var.dns_servers
  ssh_keys    = var.ssh_public_keys
  tags        = ["iac", "backup", "vlan30"]
}
