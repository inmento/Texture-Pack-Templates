#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)

write_template() {
  local game="$1"
  local label="$2"
  local id="texture_pack_${game}_template"
  local dir="$ROOT/templates/$game"

  cat > "$dir/manifest.json" <<EOF
{
  "id": "$id",
  "name": "$label Texture Pack Template",
  "version": "0.1.0",
  "entry": "main.lua",
  "api": 2,
  "game_version": ">=0.2.24",
  "category": "OTHER",
  "profile": "content",
  "games": ["$game"],
  "affects_link": false,
  "description": "Asset-free template for a player-created $label texture pack. Add only creator-owned or licensed PNG replacements under overrides/."
}
EOF

  cat > "$dir/main.lua" <<'EOF'
-- Texture Pack Template
--
-- This file intentionally does nothing. Gen1Recomp's central asset resolver
-- automatically shadows assets/generated/<relative path> with an enabled
-- mod's overrides/<relative path> file. Keep custom artwork in overrides/.
return function(_mod)
end
EOF

  cat > "$dir/overrides/README.md" <<EOF
# $label override folder

Place only your own or properly licensed PNG replacements in this folder.

For every image you replace, copy the portion of the active game's original
asset path that comes **after the assets/generated/ prefix**. For example,
assets/generated/title/copyright.png becomes
overrides/title/copyright.png.

Do not include copied game artwork, ROM files, extracted asset folders, audio,
or Lua game data in this package. A missing override safely falls back to the
player's imported game asset.
EOF

  cat > "$dir/README.md" <<EOF
# $label Texture Pack Template

This is an **empty, asset-free template** for a player-created $label texture
pack. Its game scope is intentionally limited to **$label**. The template has
no texture files of its own and does not change game data or behavior.

## Make your own pack

1. Copy this template to a new folder and give it a new folder name.
2. Change the manifest id, name, and description so the pack belongs only to
   you. Do not reuse the template id $id for a second installed pack.
3. Add creator-owned or licensed PNG files below the overrides folder.
4. Match the original path after the assets/generated prefix exactly.
5. Zip the **contents** of your new folder so manifest.json is at the ZIP root,
   then install it as its own mod.

## Examples

| Active game path | Your pack path |
|---|---|
| assets/generated/battle/front/pikachu.png | overrides/battle/front/pikachu.png |
| assets/generated/tilesets/cavern.png | overrides/tilesets/cavern.png |
| assets/generated/sprites/beauty.png | overrides/sprites/beauty.png |
| assets/generated/title/copyright.png | overrides/title/copyright.png |

## Compatibility requirements

Keep a replacement image's dimensions, transparency, tile order, frame order,
and sprite-sheet layout compatible with the image it replaces. Cosmetic changes
that keep the same layout are safe. Resizing or rearranging tiles or frames can
make maps, sprites, menus, or battle animations draw incorrectly.

If two enabled packs replace the same path, the higher-priority pack wins.
Missing files do not cause an error; the game uses its own imported image.
EOF

  touch "$dir/overrides/.gitkeep"
}

write_template red "Red"
write_template blue "Blue"
write_template yellow "Yellow"
write_template gold "Gold"
write_template silver "Silver"
write_template crystal "Crystal"

cat > "$ROOT/README.md" <<'EOF'
# Texture Pack Templates for Gen1Recomp

These six asset-free templates let players create their own texture-replacement
mods for **Red, Blue, Yellow, Gold, Silver, and Crystal**. They rely on the
engine's built-in generated-asset shadowing mechanism: an enabled template pack
can provide `overrides/<relative path>` for an original
`assets/generated/<relative path>` image.

The project ships **no game artwork, ROM data, extracted asset tree, audio, or
third-party texture pack**. It contains only manifest files, no-op Lua entries,
empty override directories, and instructions.

## Choose the edition-specific template

| Template folder | Game target |
|---|---|
| `templates/red` | Red |
| `templates/blue` | Blue |
| `templates/yellow` | Yellow |
| `templates/gold` | Gold |
| `templates/silver` | Silver |
| `templates/crystal` | Crystal |

Use the template that matches the game whose generated image paths you are
replacing. A player who wants variations for multiple games should create one
separate pack for each edition. This is more reliable than a single all-game
pack because asset filenames and image geometry differ across editions.

## Path rule

If a player's own imported game uses:

```text
assets/generated/tilesets/cavern.png
```

their texture pack uses:

```text
overrides/tilesets/cavern.png
```

The portion after `assets/generated/` must match exactly. Missing override files
fall back to the player's imported asset.

## Legal and practical boundary

A pack must contain only artwork its author created or has permission to use.
Do not package original game textures, ROM dumps, extracted cache files, Lua
game data, or audio. Keep dimensions, transparency, tile placement, and sprite
frame geometry compatible with the original image.

## Crystal coverage

The supplied Crystal archive confirms generated image families for battle art,
battle animation graphics, tilesets, sprites, title, intro, fonts, menu, Pack,
Pokédex, Pokégear, mobile UI, card flip, PC, slots, and trade art. The Crystal
template uses the same `overrides/<relative path>` contract as the other five
editions.
EOF

cat > "$ROOT/docs/CRYSTAL_PATH_REFERENCE.md" <<'EOF'
# Crystal texture-path reference

The supplied Crystal archive confirms that Crystal exposes generated image files
under `assets/generated/`. Do **not** copy that tree into a texture pack. Use it
only to identify a file the player has independently created or is licensed to
use, then place that replacement under the corresponding `overrides/` path.

| Crystal family | Supplied reference example | Pack location |
|---|---|---|
| Battle animation pose | `assets/generated/battle/anim/abra.png` | `overrides/battle/anim/abra.png` |
| Battle animation graphics | `assets/generated/battle_anims/battle_anim_gfx_aeroblast.png` | `overrides/battle_anims/battle_anim_gfx_aeroblast.png` |
| Tilesets | `assets/generated/tilesets/aerodactyl_word_room.png` | `overrides/tilesets/aerodactyl_word_room.png` |
| Overworld sprites | `assets/generated/sprites/beauty.png` | `overrides/sprites/beauty.png` |
| Title | `assets/generated/title/copyright.png` | `overrides/title/copyright.png` |
| Font | `assets/generated/fonts/font.png` | `overrides/fonts/font.png` |
| Menu | `assets/generated/menu/egg_hatch.png` | `overrides/menu/egg_hatch.png` |
| Pack | `assets/generated/pack/menu.png` | `overrides/pack/menu.png` |
| Pokédex | `assets/generated/pokedex/dex.png` | `overrides/pokedex/dex.png` |
| Pokégear | `assets/generated/pokegear/gear.png` | `overrides/pokegear/gear.png` |
| Intro | `assets/generated/intro/background_tiles.png` | `overrides/intro/background_tiles.png` |

The Crystal archive includes 1,286 generated image files spanning battle,
battle animations, card flip, credits, diploma, emotes, fonts, icons, intro,
menu, mobile, naming, Pack, PC, Pokédex, Pokégear, slots, splash, sprites,
tilesets, title, trade, and Trainer Card image families.
EOF

cat > "$ROOT/.gitignore" <<'EOF'
dist/
*.zip
.DS_Store
EOF
