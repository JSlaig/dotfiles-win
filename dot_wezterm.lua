local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- =========================
-- Window
-- =========================

config.window_decorations = "RESIZE"
config.window_background_opacity = 1

config.initial_cols = 140
config.initial_rows = 40

config.default_cwd = wezterm.home_dir

-- =========================
-- Font
-- =========================

config.font = wezterm.font("JetBrainsMonoNL Nerd Font Mono", {
    weight = "Medium",
})

config.font_size = 10.0

-- =========================
-- Background
-- =========================

local wallpaper_dir = "C:\\Users\\JSlaig\\Pictures\\terminal"
local wallpapers = {}

for _, file in ipairs(wezterm.glob(wallpaper_dir .. "/*")) do
    if file:match("%.jpg$")
        or file:match("%.jpeg$")
        or file:match("%.png$")
        or file:match("%.webp$")
    then
        table.insert(wallpapers, file)
    end
end

if #wallpapers > 0 then
    math.randomseed(os.time())
    config.window_background_image = wallpapers[math.random(#wallpapers)]

    config.window_background_image_hsb = {
        brightness = 0.25,
        hue = 1.0,
        saturation = 1.0,
    }
else
    wezterm.log_error("No wallpapers found in " .. wallpaper_dir)
end

-- =========================
-- Tabs
-- =========================

config.enable_tab_bar = false
config.use_fancy_tab_bar = false

-- =========================
-- Shell
-- =========================

config.default_prog = { "powershell.exe" }

-- =========================
-- Mappings
-- =========================

config.keys = {
    {
        key = "v",
        mods = "CTRL",
        action = wezterm.action.PasteFrom("Clipboard"),
    },
}

return config