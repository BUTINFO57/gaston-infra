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

# shellcheck disable=SC2317,SC2329  # invoque indirectement via trap
cleanup() { rm -rf "$TMPDIR"; }
trap cleanup EXIT

echo "=== Validation des diagrammes Mermaid ==="
echo "Répertoire : $DIR"
echo ""

# Extraire tous les blocs Mermaid dans des fichiers .mmd individuels
while IFS= read -r -d '' file; do
    awk '/^```mermaid$/,/^```$/' "$file" | grep -v '```' > /dev/null 2>&1 || continue

    BLOCK=0
    awk '/^```mermaid$/{p=1; next} /^```$/{if(p) print "---BLOCK_END---"; p=0} p' "$file" | \
    while IFS= read -r line; do
        if [ "$line" = "---BLOCK_END---" ]; then
            BLOCK=$((BLOCK + 1))
            # Écrire un marqueur indiquant le fichier source et le numéro de bloc
            echo "${file}::${BLOCK}" > "$TMPDIR/meta_$(basename "$file" .md)_${BLOCK}.txt"
        else
            echo "$line" >> "$TMPDIR/$(basename "$file" .md)_$((BLOCK + 1)).mmd"
        fi
    done
done < <(find "$DIR" -name "*.md" -print0)

# Valider chaque fichier .mmd extrait (pas de sous-shell → compteurs conservés)
for mmd_file in "$TMPDIR"/*.mmd; do
    [ -f "$mmd_file" ] || continue
    TOTAL=$((TOTAL + 1))
    base="$(basename "$mmd_file" .mmd)"
    meta="$TMPDIR/meta_${base}.txt"
    if [ -f "$meta" ]; then
        src_info="$(cat "$meta")"
    else
        src_info="$base"
    fi
    MMDC_ARGS=(-i "$mmd_file" -o "$TMPDIR/out.svg")
    if [ -n "${PUPPETEER_CONFIG:-}" ]; then
        MMDC_ARGS+=(--puppeteerConfigFile "$PUPPETEER_CONFIG")
    fi
    if mmdc "${MMDC_ARGS[@]}" 2>"${MMDC_ERR:-/dev/null}"; then
        echo "  ✅ ${src_info}"
    else
        echo "  ❌ ${src_info} — INVALIDE"
        ERRORS=$((ERRORS + 1))
    fi
done

echo ""
echo "Total : ${TOTAL} diagramme(s) vérifié(s)"
if [ "$ERRORS" -gt 0 ]; then
    echo "❌ $ERRORS erreur(s) trouvée(s)"
    exit 1
else
    echo "✅ Tous les diagrammes Mermaid sont valides"
    exit 0
fi
