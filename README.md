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
bridges, empty override directories, and instructions.

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
