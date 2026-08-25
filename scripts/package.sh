#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
OUT="$ROOT/dist"
STAGE="$ROOT/.package-stage"
VERSION="0.2.0"
EDITIONS=(red blue yellow gold silver crystal)

rm -rf "$OUT" "$STAGE"
mkdir -p "$OUT" "$STAGE"

for edition in "${EDITIONS[@]}"; do
  src="$ROOT/templates/$edition"
  stage="$STAGE/$edition"
  mkdir -p "$stage/overrides"
  cp "$src/manifest.json" "$src/main.lua" "$src/README.md" "$ROOT/LICENSE" "$stage/"
  cp "$src/overrides/README.md" "$src/overrides/.gitkeep" "$stage/overrides/"
  (cd "$stage" && zip -q -r "$OUT/${edition}-texture-pack-template-${VERSION}.zip" .)
done

# The source bundle is for creators who want every edition template and the
# Crystal path reference. It contains no cache, archive, image, audio, or Lua
# game data beyond the six visual-only loader bridge entrypoints.
source_stage="$STAGE/Texture-Pack-Templates-${VERSION}"
mkdir -p "$source_stage"
cp -a "$ROOT/README.md" "$ROOT/LICENSE" "$ROOT/docs" "$ROOT/templates" "$source_stage/"
(cd "$STAGE" && zip -q -r "$OUT/Texture-Pack-Templates-${VERSION}-source.zip" "Texture-Pack-Templates-${VERSION}")

for archive in "$OUT"/*.zip; do
  entries=$(unzip -Z1 "$archive")
  if printf '%s\n' "$entries" | grep -qE '\.(png|jpe?g|webp|bin|wav|ogg|mp3|7z)$|(^|/)(assets|data)/generated/|(^|/)crystal\.zip$'; then
    echo "forbidden game-derived payload in $(basename "$archive")" >&2
    exit 1
  fi
  printf '%s\n' "$(basename "$archive")"
done
