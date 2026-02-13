#!/usr/bin/env bash
# ===========================================================================
# validate.sh — Valider la syntaxe Terraform (lab + prod)
# Usage : bash iac/terraform/scripts/validate.sh
# ===========================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TF_ROOT="$(dirname "$SCRIPT_DIR")"

ERRORS=0

for env in lab prod; do
  echo "=== Validation Terraform : ${env} ==="
  DIR="${TF_ROOT}/${env}"

  if [ ! -d "$DIR" ]; then
    echo "  ⚠️  Répertoire ${DIR} introuvable, ignoré."
    continue
  fi

  cd "$DIR"

  echo "  → terraform init -backend=false"
  terraform init -backend=false -input=false > /dev/null 2>&1 || {
    echo "  ❌ terraform init échoué pour ${env}"
    ERRORS=$((ERRORS + 1))
    cd "$TF_ROOT"
    continue
  }

  echo "  → terraform validate"
  if terraform validate; then
    echo "  ✅ ${env} — valide"
  else
    echo "  ❌ ${env} — invalide"
    ERRORS=$((ERRORS + 1))
  fi

  cd "$TF_ROOT"
done

echo ""
if [ "$ERRORS" -gt 0 ]; then
  echo "❌ ${ERRORS} erreur(s) de validation"
  exit 1
else
  echo "✅ Toutes les configurations Terraform sont valides"
fi
