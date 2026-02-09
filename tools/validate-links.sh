#!/usr/bin/env bash
# =============================================================================
# validate-links.sh — Vérifier les liens cassés dans la documentation
# Utilisation : ./tools/validate-links.sh [répertoire]
# Requis : lychee (https://github.com/lycheeverse/lychee)
# =============================================================================
set -euo pipefail

DIR="${1:-.}"

echo "=== Validation des liens ==="
echo "Répertoire : $DIR"
echo ""

if ! command -v lychee &> /dev/null; then
    echo "❌ lychee non trouvé. Installer : cargo install lychee"
    echo "   ou : brew install lychee"
    echo "   ou : télécharger depuis https://github.com/lycheeverse/lychee/releases"
    exit 1
fi

lychee \
    --offline \
    --no-progress \
    --format detailed \
    --exclude-path "node_modules" \
    --exclude-path ".git" \
    --exclude-path "*.example" \
    "$DIR/**/*.md"

EXIT_CODE=$?

echo ""
if [ $EXIT_CODE -eq 0 ]; then
    echo "✅ Tous les liens sont valides"
else
    echo "❌ Liens cassés trouvés (code de sortie : $EXIT_CODE)"
fi

exit $EXIT_CODE
