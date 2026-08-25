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
