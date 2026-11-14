#!/usr/bin/env bash
# Verplaatst het meest recente .html- en .js-bestand uit de bronmap
# (standaard ~/Downloads) naar deze repo als index.html en sw.js.
# Kopieert .png- en .svg-bestanden die maximaal een uur oud zijn,
# met behoud van hun bestandsnaam.
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
assets=("$SRC"/*.png "$SRC"/*.svg)
now="$(date +%s)"
recent_assets=()

for asset in "${assets[@]}"; do
  if [ -f "$asset" ]; then
    created="$(stat -f %B "$asset")"
    age=$((now - created))
    if [ "$age" -ge 0 ] && [ "$age" -le 3600 ]; then
      recent_assets+=("$asset")
    fi
  fi
done

if [ -z "$html" ] && [ -z "$js" ] && [ "${#recent_assets[@]}" -eq 0 ]; then
  echo "Geen .html- of .js-bestand, of recent .png/.svg-bestand (maximaal een uur oud) gevonden in $SRC" >&2
  exit 1
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

for asset in "${recent_assets[@]}"; do
  filename="$(basename "$asset")"
  cp -f "$asset" "$DEST/$filename"
  echo "$asset -> $DEST/$filename"
done
