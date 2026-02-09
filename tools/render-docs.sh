#!/usr/bin/env bash
# =============================================================================
# render-docs.sh — Générer la documentation Markdown en HTML (optionnel)
# Utilisation : ./tools/render-docs.sh [répertoire_sortie]
# Requis : pandoc (https://pandoc.org/)
# =============================================================================
set -euo pipefail

OUTPUT_DIR="${1:-build}"

echo "=== Génération de la documentation ==="
echo "Sortie : $OUTPUT_DIR"
echo ""

if ! command -v pandoc &> /dev/null; then
    echo "❌ pandoc non trouvé. Installer : apt install pandoc"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

TOTAL=0
while IFS= read -r -d '' file; do
    RELATIVE="${file#./}"
    OUT_FILE="$OUTPUT_DIR/${RELATIVE%.md}.html"
    OUT_SUBDIR=$(dirname "$OUT_FILE")
    mkdir -p "$OUT_SUBDIR"

    pandoc "$file" \
        --standalone \
        --metadata title="$(head -1 "$file" | sed 's/^# //')" \
        --template=default \
        -o "$OUT_FILE" 2>/dev/null || {
        # Fallback without template
        pandoc "$file" --standalone -o "$OUT_FILE"
    }

    TOTAL=$((TOTAL + 1))
    echo "  📄 $RELATIVE → $OUT_FILE"
done < <(find . -name "*.md" -not -path "./.git/*" -not -path "./node_modules/*" -not -path "./$OUTPUT_DIR/*" -print0)

echo ""
echo "✅ $TOTAL fichiers générés dans $OUTPUT_DIR/"
