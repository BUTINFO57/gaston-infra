#!/usr/bin/env bash
# ===========================================================================
# tf-to-ansible-inventory.sh — Générer un inventaire Ansible depuis
#                                les outputs Terraform
# Usage : bash tools/tf-to-ansible-inventory.sh [lab|prod] [fichier_sortie]
# ===========================================================================
set -euo pipefail

ENV="${1:-lab}"
OUTPUT="${2:-automation/ansible/inventories/${ENV}.ini}"

TF_DIR="iac/terraform/${ENV}"

if [ ! -d "$TF_DIR" ]; then
  echo "❌ Répertoire Terraform introuvable : ${TF_DIR}"
  echo "   Usage : $0 [lab|prod] [fichier_sortie]"
  exit 1
fi

echo "=== Génération de l'inventaire Ansible ==="
echo "Environnement : ${ENV}"
echo "Source Terraform : ${TF_DIR}"
echo "Sortie : ${OUTPUT}"
echo ""

# Récupérer les outputs Terraform au format JSON
VM_IPS=$(terraform -chdir="$TF_DIR" output -json vm_ips 2>/dev/null) || {
  echo "❌ Impossible de lire les outputs Terraform."
  echo "   Avez-vous exécuté 'terraform apply' dans ${TF_DIR} ?"
  exit 1
}

# Extraire les IPs (retirer le masque CIDR)
strip_cidr() {
  echo "$1" | sed 's|/[0-9]*||'
}

AD_DC01=$(strip_cidr "$(echo "$VM_IPS" | python3 -c "import sys,json; print(json.load(sys.stdin)['ad_dc01'])")")
AD_DC02=$(strip_cidr "$(echo "$VM_IPS" | python3 -c "import sys,json; print(json.load(sys.stdin)['ad_dc02'])")")
MON_01=$(strip_cidr "$(echo "$VM_IPS" | python3 -c "import sys,json; print(json.load(sys.stdin)['mon_01'])")")
MAIL_01=$(strip_cidr "$(echo "$VM_IPS" | python3 -c "import sys,json; print(json.load(sys.stdin)['mail_01'])")")
RP_PROD01=$(strip_cidr "$(echo "$VM_IPS" | python3 -c "import sys,json; print(json.load(sys.stdin)['rp_prod01'])")")
WEB_WP01=$(strip_cidr "$(echo "$VM_IPS" | python3 -c "import sys,json; print(json.load(sys.stdin)['web_wp01'])")")
MARIA_PROD01=$(strip_cidr "$(echo "$VM_IPS" | python3 -c "import sys,json; print(json.load(sys.stdin)['maria_prod01'])")")
PBS=$(strip_cidr "$(echo "$VM_IPS" | python3 -c "import sys,json; print(json.load(sys.stdin)['pbs'])")")

# Écrire l'inventaire
mkdir -p "$(dirname "$OUTPUT")"
cat > "$OUTPUT" <<EOF
# =============================================================================
# Inventaire Ansible — ${ENV^^}
# Généré automatiquement depuis les outputs Terraform le $(date +%Y-%m-%d)
# Source : ${TF_DIR}
# =============================================================================

[domain_controllers]
ad-dc01 ansible_host=${AD_DC01}
ad-dc02 ansible_host=${AD_DC02}

[mail]
mail-01 ansible_host=${MAIL_01}

[monitoring]
mon-01 ansible_host=${MON_01}

[web]
rp-prod01    ansible_host=${RP_PROD01}
web-wp01     ansible_host=${WEB_WP01}
maria-prod01 ansible_host=${MARIA_PROD01}

[backup]
pbs ansible_host=${PBS}

[linux:children]
domain_controllers
mail
monitoring
web
backup

[linux:vars]
ansible_user=deploy
ansible_python_interpreter=/usr/bin/python3
EOF

echo "✅ Inventaire généré : ${OUTPUT}"
echo ""
echo "Contenu :"
cat "$OUTPUT"
