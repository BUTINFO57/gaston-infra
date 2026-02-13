# ===========================================================================
# LAB — Outputs
# ===========================================================================

output "vm_ips" {
  description = "Adresses IP de toutes les VMs LAB"
  value = {
    ad_dc01      = module.ad_dc01.ipv4_address
    ad_dc02      = module.ad_dc02.ipv4_address
    mon_01       = module.mon_01.ipv4_address
    mail_01      = module.mail_01.ipv4_address
    rp_prod01    = module.rp_prod01.ipv4_address
    web_wp01     = module.web_wp01.ipv4_address
    maria_prod01 = module.maria_prod01.ipv4_address
    pbs          = module.pbs.ipv4_address
  }
}

output "vm_names" {
  description = "Noms de toutes les VMs LAB"
  value = {
    ad_dc01      = module.ad_dc01.vm_name
    ad_dc02      = module.ad_dc02.vm_name
    mon_01       = module.mon_01.vm_name
    mail_01      = module.mail_01.vm_name
    rp_prod01    = module.rp_prod01.vm_name
    web_wp01     = module.web_wp01.vm_name
    maria_prod01 = module.maria_prod01.vm_name
    pbs          = module.pbs.vm_name
  }
}

output "summary" {
  description = "Résumé du déploiement LAB"
  value       = <<-EOT
    ╔══════════════════════════════════════════════════════╗
    ║  LAB — Les Saveurs de Gaston — Déploiement terminé  ║
    ╠══════════════════════════════════════════════════════╣
    ║  VLAN 10 (Admin)                                    ║
    ║    AD-DC01      : ${module.ad_dc01.ipv4_address}
    ║    AD-DC02      : ${module.ad_dc02.ipv4_address}
    ║    MON-01       : ${module.mon_01.ipv4_address}
    ║    MAIL-01      : ${module.mail_01.ipv4_address}
    ║  VLAN 20 (Prod)                                     ║
    ║    rp-prod01    : ${module.rp_prod01.ipv4_address}
    ║    web-wp01     : ${module.web_wp01.ipv4_address}
    ║    maria-prod01 : ${module.maria_prod01.ipv4_address}
    ║  VLAN 30 (Backup)                                   ║
    ║    PBS          : ${module.pbs.ipv4_address}
    ╚══════════════════════════════════════════════════════╝
  EOT
}
