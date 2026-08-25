# Red visual override folder

Place only your own or properly licensed **visual** replacements in this
folder. Preserve the exact relative path after the active game's
`assets/generated/` prefix. For example,
`assets/generated/title/copyright.png` becomes
`overrides/title/copyright.png`.

This template covers normal generated-image resolution and direct presentation
loads used by animated intro and title sequences. In the supplied game
references, the intro is built from PNG frame, sprite, and tile-sheet assets;
it is **not** a standalone video file. The bridge also routes a future
`love.graphics.newVideo` generated-asset call through the same path rule if
that runtime loader is used.

Do not include copied game artwork, ROM files, extracted asset folders, Lua game
data, `.bin` files, or audio in this package. A missing override safely falls
back to the player's imported asset.
