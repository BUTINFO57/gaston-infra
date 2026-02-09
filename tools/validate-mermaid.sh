#!/usr/bin/env bash
# =============================================================================
# validate-mermaid.sh — Extraire et valider les diagrammes Mermaid des fichiers .md
# Utilisation : ./tools/validate-mermaid.sh [répertoire]
# Requis : @mermaid-js/mermaid-cli (npm i -g @mermaid-js/mermaid-cli)
# =============================================================================
set -euo pipefail

DIR="${1:-.}"
TMPDIR=$(mktemp -d)
ERRORS=0
TOTAL=0

cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "=== Validation des diagrammes Mermaid ==="
echo "Répertoire : $DIR"
echo ""

# Find all .md files
while IFS= read -r -d '' file; do
    # Extract mermaid blocks
    awk '/^```mermaid$/,/^```$/' "$file" | grep -v '```' > /dev/null 2>&1 || continue

    BLOCK=0
    awk '/^```mermaid$/{p=1; next} /^```$/{if(p) print "---BLOCK_END---"; p=0} p' "$file" | \
    while IFS= read -r line; do
        if [ "$line" = "---BLOCK_END---" ]; then
            BLOCK=$((BLOCK + 1))
            TOTAL=$((TOTAL + 1))
            MMD_FILE="$TMPDIR/$(basename "$file" .md)_${BLOCK}.mmd"
            # Validate with mmdc
            if mmdc -i "$MMD_FILE" -o "$TMPDIR/out.svg" 2>/dev/null; then
                echo "  ✅ $file — bloc $BLOCK"
            else
                echo "  ❌ $file — bloc $BLOCK — INVALIDE"
                ERRORS=$((ERRORS + 1))
            fi
        else
            MMD_FILE="$TMPDIR/$(basename "$file" .md)_$((BLOCK + 1)).mmd"
            echo "$line" >> "$MMD_FILE"
        fi
    done
done < <(find "$DIR" -name "*.md" -print0)

echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "❌ $ERRORS erreur(s) trouvée(s)"
    exit 1
else
    echo "✅ Tous les diagrammes Mermaid sont valides"
    exit 0
fi
