#!/usr/bin/env bash
# Verplaatst het meest recente .html-, .js- en .md-bestand uit de bronmap
# (standaard ~/Downloads) naar deze repo als index.html, sw.js en README.md.
# Gebruik: ./update.sh [bronmap]
set -euo pipefail

SRC="${1:-$HOME/Downloads}"
DEST="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[ -d "$SRC" ] || { echo "Bronmap bestaat niet: $SRC" >&2; exit 1; }

newest() {
  ls -t "$SRC"/*."$1" 2>/dev/null | head -n 1 || true
}

html="$(newest html)"
js="$(newest js)"
md="$(newest md)"

[ -n "$html" ] || { echo "Geen .html-bestand gevonden in $SRC" >&2; exit 1; }
[ -n "$js" ] || { echo "Geen .js-bestand gevonden in $SRC" >&2; exit 1; }
[ -n "$md" ] || { echo "Geen .md-bestand gevonden in $SRC" >&2; exit 1; }

mv -f "$html" "$DEST/index.html"
mv -f "$js" "$DEST/sw.js"
mv -f "$md" "$DEST/README.md"

echo "$html -> $DEST/index.html"
echo "$js -> $DEST/sw.js"
echo "$md -> $DEST/README.md"
