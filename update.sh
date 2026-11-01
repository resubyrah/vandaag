#!/usr/bin/env bash
# Verplaatst het meest recente .html- en .js-bestand uit de bronmap
# (standaard ~/Downloads) naar deze repo als index.html en sw.js.
# Het meest recente .md-bestand gaat mee (met behoud van naam), maar alleen
# als de wijzigingstijd binnen TOLERANCE seconden (standaard 300) van die van
# het .html- en .js-bestand ligt.
# Gebruik: [TOLERANCE=300] ./update.sh [bronmap]
set -euo pipefail

SRC="${1:-$HOME/Downloads}"
TOLERANCE="${TOLERANCE:-300}"
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

close() {
  local diff=$(( $(stat -f %m "$1") - $(stat -f %m "$2") ))
  [ "${diff#-}" -le "$TOLERANCE" ]
}

move_md=false
if [ -n "$md" ] && close "$md" "$html" && close "$md" "$js"; then
  move_md=true
fi

mv -f "$html" "$DEST/index.html"
mv -f "$js" "$DEST/sw.js"

echo "$html -> $DEST/index.html"
echo "$js -> $DEST/sw.js"

if $move_md; then
  mv -f "$md" "$DEST/"
  echo "$md -> $DEST/$(basename "$md")"
elif [ -n "$md" ]; then
  echo "Overgeslagen (tijd wijkt te veel af): $md"
fi
