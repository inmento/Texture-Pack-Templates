import fs from "node:fs";
import path from "node:path";

const root = path.resolve(import.meta.dirname, "..");
const editions = ["red", "blue", "yellow", "gold", "silver", "crystal"];
const forbiddenExtensions = new Set([".png", ".jpg", ".jpeg", ".webp", ".bin", ".wav", ".ogg", ".mp3", ".zip", ".7z"]);
let failures = 0;

function fail(message) {
  failures += 1;
  console.error(`FAIL: ${message}`);
}

function walk(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  return entries.flatMap((entry) => {
    const target = path.join(dir, entry.name);
    return entry.isDirectory() ? walk(target) : [target];
  });
}

for (const edition of editions) {
  const dir = path.join(root, "templates", edition);
  const manifestPath = path.join(dir, "manifest.json");
  const entryPath = path.join(dir, "main.lua");
  const overrideReadme = path.join(dir, "overrides", "README.md");
  const marker = path.join(dir, "overrides", ".gitkeep");

  if (!fs.existsSync(manifestPath)) {
    fail(`${edition}: manifest.json is missing`);
    continue;
  }
  const manifest = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
  if (manifest.id !== `texture_pack_${edition}_template`) fail(`${edition}: unexpected manifest id`);
  if (!Array.isArray(manifest.games) || manifest.games.length !== 1 || manifest.games[0] !== edition) {
    fail(`${edition}: manifest must target only ${edition}`);
  }
  if (manifest.version !== "0.2.0") fail(`${edition}: expected complete-visual template version 0.2.0`);
  if (manifest.api !== 2 || manifest.game_version !== ">=0.2.24") fail(`${edition}: engine requirement drifted`);
  if (manifest.entry !== "main.lua") fail(`${edition}: expected main.lua entry`);
  const entry = fs.existsSync(entryPath) ? fs.readFileSync(entryPath, "utf8") : "";
  for (const required of ["assets/generated/", "overrides/", "newImage", "newImageData", "newVideo", "mod:info", "mod.assets:path"]) {
    if (!entry.includes(required)) fail(`${edition}: missing complete visual-loader bridge token ${required}`);
  }
  if (!fs.existsSync(overrideReadme) || !fs.existsSync(marker)) fail(`${edition}: override directory documentation or marker is missing`);

  for (const file of walk(dir)) {
    const ext = path.extname(file).toLowerCase();
    if (forbiddenExtensions.has(ext)) fail(`${edition}: forbidden payload ${path.relative(root, file)}`);
    if (ext === ".lua" && path.basename(file) !== "main.lua") fail(`${edition}: unexpected Lua file ${path.relative(root, file)}`);
  }
}

if (failures > 0) process.exit(1);
console.log(`PASS: ${editions.length} edition-specific templates satisfy manifest, complete visual-loader bridge, and asset-free safeguards.`);
