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

if [ -z "$html" ] && [ -z "$js" ] && [ -z "$md" ]; then
  echo "Geen .html-, .js- of .md-bestand gevonden in $SRC" >&2
  exit 1
fi

close() {
  local diff=$(( $(stat -f %m "$1") - $(stat -f %m "$2") ))
  [ "${diff#-}" -le "$TOLERANCE" ]
}

move_md=false
if [ -n "$md" ]; then
  move_md=true
  for ref in "$html" "$js"; do
    if [ -n "$ref" ] && ! close "$md" "$ref"; then move_md=false; fi
  done
fi

if [ -n "$html" ]; then
  mv -f "$html" "$DEST/index.html"
  echo "$html -> $DEST/index.html"
else
  echo "Geen .html-bestand gevonden, overgeslagen"
fi

if [ -n "$js" ]; then
  mv -f "$js" "$DEST/sw.js"
  echo "$js -> $DEST/sw.js"
else
  echo "Geen .js-bestand gevonden, overgeslagen"
fi

if $move_md; then
  mv -f "$md" "$DEST/"
  echo "$md -> $DEST/$(basename "$md")"
elif [ -n "$md" ]; then
  echo "Overgeslagen (tijd wijkt te veel af): $md"
fi
