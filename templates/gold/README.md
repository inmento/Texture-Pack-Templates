# Gold Texture Pack Template

This is an **empty, asset-free template** for a player-created Gold texture
pack. Its game scope is intentionally limited to **Gold**. The template has
no texture files of its own and does not change game data or behavior.

## Make your own pack

1. Copy this template to a new folder and give it a new folder name.
2. Change the manifest id, name, and description so the pack belongs only to
   you. Do not reuse the template id texture_pack_gold_template for a second installed pack.
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
