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
