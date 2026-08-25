#!/usr/bin/env bash
set -euo pipefail

ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
VERSION="0.2.0"

write_template() {
  local game="$1"
  local label="$2"
  local id="texture_pack_${game}_template"
  local dir="$ROOT/templates/$game"
  local game_version=">=0.2.18"
  # Crystal was added after 0.2.18, so its edition-specific template must not
  # promise installation on an engine that cannot select or load Crystal.
  if [[ "$game" == "crystal" ]]; then game_version=">=0.2.24"; fi

  cat > "$dir/manifest.json" <<EOF
{
  "id": "$id",
  "name": "$label Texture Pack Template",
  "version": "$VERSION",
  "entry": "main.lua",
  "api": 2,
  "game_version": "$game_version",
  "category": "OTHER",
  "profile": "content",
  "games": ["$game"],
  "affects_link": false,
  "description": "Asset-free template for a player-created $label visual pack. Add only creator-owned or licensed replacements below overrides/."
}
EOF

  cat > "$dir/main.lua" <<'EOF'
-- Texture Pack Template — complete generated-visual override bridge
--
-- Gen1Recomp resolves normal assets/generated/<relative> image loads through
-- enabled mods' overrides/<relative> files. This narrow bridge also covers
-- direct LÖVE visual-loader calls made by engine presentation code, including
-- the animated intro/title path. It changes only a matching generated visual
-- path owned by this pack; data, audio, and all non-generated paths pass through.
local GENERATED = "assets/generated/"

return function(mod)
  local function resolveVisual(path)
    if type(path) ~= "string" or path:sub(1, #GENERATED) ~= GENERATED then
      return path
    end
    local relative = path:sub(#GENERATED + 1)
    local override = "overrides/" .. relative
    local info = mod:info(override)
    if info and info.type == "file" then
      return mod.assets:path(override)
    end
    return path
  end

  local function wrapLoader(owner, name)
    if type(owner) ~= "table" or type(owner[name]) ~= "function" then return end
    local original = owner[name]
    owner[name] = function(path, ...)
      return original(resolveVisual(path), ...)
    end
  end

  -- Image, image-data, and video calls all retain their original arguments;
  -- only an existing overrides/<relative> visual file changes the source path.
  if love then
    wrapLoader(love.graphics, "newImage")
    wrapLoader(love.image, "newImageData")
    wrapLoader(love.graphics, "newVideo")
  end
end
EOF

  cat > "$dir/overrides/README.md" <<EOF
# $label visual override folder

Place only your own or properly licensed **visual** replacements in this
folder. Preserve the exact relative path after the active game's
\`assets/generated/\` prefix. For example,
\`assets/generated/title/copyright.png\` becomes
\`overrides/title/copyright.png\`.

This template covers normal generated-image resolution and direct presentation
loads used by animated intro and title sequences. In the supplied game
references, the intro is built from PNG frame, sprite, and tile-sheet assets;
it is **not** a standalone video file. The bridge also routes a future
\`love.graphics.newVideo\` generated-asset call through the same path rule if
that runtime loader is used.

Do not include copied game artwork, ROM files, extracted asset folders, Lua game
data, \`.bin\` files, or audio in this package. A missing override safely falls
back to the player's imported asset.
EOF

  cat > "$dir/README.md" <<EOF
# $label Texture Pack Template

This is an **empty, asset-free template** for a player-created $label visual
pack. Its game scope is intentionally limited to **$label**. The template has
no visual files of its own and does not change game data or behavior. It requires
Gen1Recomp **$game_version**.

## Make your own pack

1. Copy this template to a new folder and give it a new folder name.
2. Change the manifest id, name, and description so the pack belongs only to
   you. Do not reuse the template id $id for a second installed pack.
3. Add creator-owned or licensed visual replacement files below \`overrides/\`.
4. Match the original path after the \`assets/generated/\` prefix exactly,
   including subdirectories and filename extension.
5. Zip the **contents** of your new folder so \`manifest.json\` is at the ZIP
   root, then install it as its own mod.

## Visual path rule

| Active game path | Your pack path | Covered loader route |
|---|---|---|
| \`assets/generated/battle/front/pikachu.png\` | \`overrides/battle/front/pikachu.png\` | Standard image resolution |
| \`assets/generated/tilesets/cavern.png\` | \`overrides/tilesets/cavern.png\` | Standard image resolution |
| \`assets/generated/sprites/beauty.png\` | \`overrides/sprites/beauty.png\` | Standard image resolution |
| \`assets/generated/title/copyright.png\` | \`overrides/title/copyright.png\` | Direct title/intro image load |
| \`assets/generated/intro/shrink1.png\` | \`overrides/intro/shrink1.png\` | Animated intro frame/tile load |

The bridge covers generated paths passed to LÖVE's image, image-data, and video
loaders. It does not replace audio, generated Lua/data files, or runtime
program files. Those surfaces belong to the dedicated audio and gameplay mod
systems, not a texture pack.

## Compatibility requirements

Keep a replacement image's dimensions, transparency, tile order, frame order,
and sprite-sheet layout compatible with the image it replaces. Cosmetic changes
that keep the same layout are safe. Resizing or rearranging tiles or frames can
make maps, sprites, menus, intro animation, title screens, or battle animation
draw incorrectly.

If two enabled packs replace the same path, the higher-priority pack wins.
Missing files do not cause an error; the game uses its own imported asset.
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

These six asset-free templates let players create their own complete visual
replacement mods for **Red, Blue, Yellow, Gold, Silver, and Crystal**. A pack
can replace any visual file the active game loads below
`assets/generated/<relative path>` by placing a creator-owned or licensed file
at `overrides/<relative path>`.

The templates cover the engine's ordinary generated-image resolver and a narrow
visual-loader bridge for direct LÖVE image, image-data, and video calls. This
means title and intro visuals are included rather than being treated as a
special exception. In the supplied Red/Blue/Yellow/Gold/Silver and Crystal
references, intros are animated from generated PNG frames, sprite sheets, and
tile sheets—not standalone video files—so replace the relevant `intro/` PNGs.
If a supported runtime later loads a generated video through
`love.graphics.newVideo`, the same relative override rule applies.

The project ships **no game artwork, ROM data, extracted asset tree, audio, or
third-party texture pack**. It contains only manifests, narrow visual path
bridges, empty override directories, and instructions. Red, Blue, Yellow, Gold,
and Silver templates support Gen1Recomp `>=0.2.18`; the Crystal template retains
its later engine floor because Crystal was not an available edition in 0.2.18.

## Choose the edition-specific template

| Template folder | Game target |
|---|---|
| `templates/red` | Red |
| `templates/blue` | Blue |
| `templates/yellow` | Yellow |
| `templates/gold` | Gold |
| `templates/silver` | Silver |
| `templates/crystal` | Crystal |

Use the template that matches the game whose generated visual paths you are
replacing. A player who wants variations for multiple games should create one
separate pack for each edition. This is more reliable than a single all-game
pack because asset filenames and visual geometry differ across editions.

## Path rule

If a player's imported game uses:

```text
assets/generated/tilesets/cavern.png
```

their visual pack uses:

```text
overrides/tilesets/cavern.png
```

The portion after `assets/generated/` must match exactly. Missing override files
fall back to the player's imported asset. The visual bridge never redirects
non-generated paths and only redirects a path when that pack owns a matching
override file.

## Included visual surface

The supplied reference trees show generated visual families such as battle art,
battle animations, tilesets, sprites, UI, fonts, title, intro, credits, trade,
slots, and edition-specific screens. Replace any compatible image in those
families by exact path. The templates intentionally exclude generated Lua/data,
`.bin` runtime programs, and audio; they are not visual textures and should use
the dedicated systems that own those formats.

## Legal and practical boundary

A pack must contain only artwork its author created or has permission to use.
Do not package original game textures, ROM dumps, extracted cache files, Lua
game data, audio, or runtime binaries. Keep dimensions, transparency, tile
placement, and sprite-frame geometry compatible with the original visual asset.
EOF

cat > "$ROOT/docs/CRYSTAL_PATH_REFERENCE.md" <<'EOF'
# Crystal visual-path reference

The supplied Crystal archive confirms that Crystal exposes generated visual
files under `assets/generated/`. Do **not** copy that tree into a visual pack.
Use it only to identify a file the player independently created or is licensed
to use, then place that replacement under the corresponding `overrides/` path.

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
| Intro frame/sheet | `assets/generated/intro/background_tiles.png` | `overrides/intro/background_tiles.png` |

The Crystal archive includes 1,286 generated PNG visual files spanning battle,
battle animations, card flip, credits, diploma, emotes, fonts, icons, intro,
menu, mobile, naming, Pack, PC, Pokédex, Pokégear, slots, splash, sprites,
tilesets, title, trade, and Trainer Card image families. Its intro sequence is
an animation assembled from these PNG assets, not a separately shipped video.
EOF

cat > "$ROOT/.gitignore" <<'EOF'
dist/
.package-stage/
*.zip
.DS_Store
EOF
