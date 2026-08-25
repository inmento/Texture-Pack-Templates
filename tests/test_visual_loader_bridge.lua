local root = os.getenv("TEXTURE_TEMPLATE_ROOT") or "."
local editions = { "red", "blue", "yellow", "gold", "silver", "crystal" }

local function assertEqual(actual, expected, label)
  if actual ~= expected then
    error(('%s: expected %q, got %q'):format(label, expected, actual), 0)
  end
end

for _, edition in ipairs(editions) do
  local calls = {}
  local function record(kind)
    return function(path, ...)
      calls[#calls + 1] = { kind = kind, path = path, argc = select("#", ...) }
      return { kind = kind, path = path }
    end
  end

  local love = {
    graphics = {
      newImage = record("image"),
      newVideo = record("video"),
    },
    image = {
      newImageData = record("image-data"),
    },
  }

  local owned = {
    ["overrides/title/copyright.png"] = true,
    ["overrides/intro/shrink1.png"] = true,
    ["overrides/intro/opening.webm"] = true,
  }
  local mod = {
    info = function(_, relative)
      return owned[relative] and { type = "file" } or nil
    end,
    assets = {
      path = function(_, relative)
        return "mods/test-pack/" .. relative
      end,
    },
  }

  local chunk = assert(loadfile(root .. "/templates/" .. edition .. "/main.lua"))
  setfenv(chunk, { love = love, type = type })
  local install = chunk()
  install(mod)

  assertEqual(love.graphics.newImage("assets/generated/title/copyright.png", { mipmaps = true }).path,
    "mods/test-pack/overrides/title/copyright.png", edition .. " image override")
  assertEqual(love.image.newImageData("assets/generated/intro/shrink1.png").path,
    "mods/test-pack/overrides/intro/shrink1.png", edition .. " image-data override")
  assertEqual(love.graphics.newVideo("assets/generated/intro/opening.webm").path,
    "mods/test-pack/overrides/intro/opening.webm", edition .. " video override")
  assertEqual(love.graphics.newImage("assets/generated/tilesets/cavern.png").path,
    "assets/generated/tilesets/cavern.png", edition .. " missing generated fallback")
  assertEqual(love.graphics.newImage("mods/other/image.png").path,
    "mods/other/image.png", edition .. " non-generated passthrough")

  if #calls ~= 5 then error(edition .. ": expected five forwarded loader calls", 0) end
end

print("texture template visual loader bridge: passed")
