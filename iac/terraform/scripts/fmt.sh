#!/usr/bin/env bash
# ===========================================================================
# fmt.sh — Vérifier le formatage Terraform (lab + prod + modules)
# Usage : bash iac/terraform/scripts/fmt.sh [--fix]
# ===========================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TF_ROOT="$(dirname "$SCRIPT_DIR")"

FIX=false
if [ "${1:-}" = "--fix" ]; then
  FIX=true
fi

echo "=== Vérification du formatage Terraform ==="
echo "Répertoire : ${TF_ROOT}"
echo ""

if $FIX; then
  echo "Mode correction activé (--fix)"
  terraform -chdir="$TF_ROOT" fmt -recursive
  echo "✅ Formatage appliqué"
else
  if terraform -chdir="$TF_ROOT" fmt -check -recursive; then
    echo "✅ Formatage correct"
  else
    echo ""
    echo "❌ Fichiers mal formatés détectés."
    echo "   Corriger avec : bash iac/terraform/scripts/fmt.sh --fix"
    exit 1
  fi
fi
