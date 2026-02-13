# ===========================================================================
# PROD — Outputs
# ===========================================================================

output "vm_ips" {
  description = "Adresses IP de toutes les VMs PROD"
  value = {
    ad_dc01      = module.ad_dc01.ipv4_address
    ad_dc02      = module.ad_dc02.ipv4_address
    mon_01       = module.mon_01.ipv4_address
    mail_01      = module.mail_01.ipv4_address
    glpi         = module.glpi.ipv4_address
    rp_prod01    = module.rp_prod01.ipv4_address
    web_wp01     = module.web_wp01.ipv4_address
    maria_prod01 = module.maria_prod01.ipv4_address
    pbs          = module.pbs.ipv4_address
  }
}

output "vm_placement" {
  description = "Placement des VMs sur les nœuds"
  value = {
    ad_dc01      = module.ad_dc01.node_name
    ad_dc02      = module.ad_dc02.node_name
    mon_01       = module.mon_01.node_name
    mail_01      = module.mail_01.node_name
    glpi         = module.glpi.node_name
    rp_prod01    = module.rp_prod01.node_name
    web_wp01     = module.web_wp01.node_name
    maria_prod01 = module.maria_prod01.node_name
    pbs          = module.pbs.node_name
  }
}

output "summary" {
  description = "Résumé du déploiement PROD"
  value       = <<-EOT
    ╔══════════════════════════════════════════════════════╗
    ║ PROD — Les Saveurs de Gaston — Déploiement terminé  ║
    ╠══════════════════════════════════════════════════════╣
    ║  VLAN 10 (Admin)           Nœud                     ║
    ║    AD-DC01      : ${module.ad_dc01.ipv4_address}  (${module.ad_dc01.node_name})
    ║    AD-DC02      : ${module.ad_dc02.ipv4_address}  (${module.ad_dc02.node_name})
    ║    MON-01       : ${module.mon_01.ipv4_address}  (${module.mon_01.node_name})
    ║    MAIL-01      : ${module.mail_01.ipv4_address}  (${module.mail_01.node_name})
    ║    GLPI         : ${module.glpi.ipv4_address}  (${module.glpi.node_name})
    ║  VLAN 20 (Prod)                                     ║
    ║    rp-prod01    : ${module.rp_prod01.ipv4_address}  (${module.rp_prod01.node_name})
    ║    web-wp01     : ${module.web_wp01.ipv4_address}  (${module.web_wp01.node_name})
    ║    maria-prod01 : ${module.maria_prod01.ipv4_address}  (${module.maria_prod01.node_name})
    ║  VLAN 30 (Backup)                                   ║
    ║    PBS          : ${module.pbs.ipv4_address}  (${module.pbs.node_name})
    ╚══════════════════════════════════════════════════════╝
  EOT
}
