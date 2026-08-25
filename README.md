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
