# Yellow Texture Pack Template

This is an **empty, asset-free template** for a player-created Yellow visual
pack. Its game scope is intentionally limited to **Yellow**. The template has
no visual files of its own and does not change game data or behavior. It requires
Gen1Recomp **>=0.2.18**.

## Make your own pack

1. Copy this template to a new folder and give it a new folder name.
2. Change the manifest id, name, and description so the pack belongs only to
   you. Do not reuse the template id texture_pack_yellow_template for a second installed pack.
3. Add creator-owned or licensed visual replacement files below `overrides/`.
4. Match the original path after the `assets/generated/` prefix exactly,
   including subdirectories and filename extension.
5. Zip the **contents** of your new folder so `manifest.json` is at the ZIP
   root, then install it as its own mod.

## Visual path rule

| Active game path | Your pack path | Covered loader route |
|---|---|---|
| `assets/generated/battle/front/pikachu.png` | `overrides/battle/front/pikachu.png` | Standard image resolution |
| `assets/generated/tilesets/cavern.png` | `overrides/tilesets/cavern.png` | Standard image resolution |
| `assets/generated/sprites/beauty.png` | `overrides/sprites/beauty.png` | Standard image resolution |
| `assets/generated/title/copyright.png` | `overrides/title/copyright.png` | Direct title/intro image load |
| `assets/generated/intro/shrink1.png` | `overrides/intro/shrink1.png` | Animated intro frame/tile load |

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
