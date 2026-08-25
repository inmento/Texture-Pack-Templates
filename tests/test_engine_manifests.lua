local stage = os.getenv("TEMPLATE_STAGE") or "mods"

package.path = "./?.lua;./?/init.lua;" .. package.path

local GameVersion = require("src.core.GameVersion")
local Sdk = require("tests.modkit.sdk")

local editions = { "red", "blue", "yellow", "gold", "silver", "crystal" }

for _, edition in ipairs(editions) do
  GameVersion.set(edition)
  local result = Sdk.loadMod(stage .. "/texture_pack_" .. edition .. "_template", {
    root = ".",
    generation = GameVersion.generation(edition),
  })

  assert(result.mod, edition .. " template did not load")

  assert(result.mod.manifest.id == "texture_pack_" .. edition .. "_template",
    edition .. " template loaded with an unexpected id")
  assert(#(result.errors or {}) == 0, edition .. " template reported loader errors")
  result.release()
end

GameVersion.set("red")
print("PASS: all six texture-pack template manifests load on their matching engine runtime.")
