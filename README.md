# dotfiles-win

My [chezmoi](https://www.chezmoi.io/) dotfiles for Windows. Manages configs for
**WezTerm**, the **Herdr** terminal multiplexer, the **opencode** AI CLI, and an
external **Neovim** config pulled straight from Git, all tied together by a
local OmniRoute model gateway.

## What's here

| Path | Manages | Notes |
| --- | --- | --- |
| `dot_wezterm.lua` | `~/.wezterm.lua` | Terminal: window size, font, wallpaper background, tab bar, Paste keybinding |
| `AppData/Roaming/herdr/config.toml` | `%APPDATA%\Roaming\herdr\config.toml` | Herdr keybindings (Alt-based prefix), workspace/tab/pane switching, kanagawa theme |
| `AppData/Roaming/Zed/keymap.json` | `%APPDATA%\Zed\keymap.json` | Zed keybindings (blank for now; themes/plugins/MCP to come) |
| `dot_config/opencode/` | `~/.config/opencode/` | opencode config, OmniRoute provider template, and Herdr integration plugins |
| `.chezmoiexternal.toml` | external source | Clones `https://github.com/JSlaig/nvim` into `%LOCALAPPDATA%\nvim` |

## Requirements

- [chezmoi](https://www.chezmoi.io/install/) (install via `winget install chezmoi` or `scoop install chezmoi`)
- [WezTerm](https://wezfurlong.org/wezterm/install/windows.html)
- JetBrainsMono **Nerd Font Mono** (`JetBrainsMonoNL Nerd Font Mono`)
- [Herdr](https://herdr.dev) with the opencode integration
- omni-online/offline OmniRoute gateway reachable at `http://pi.lan:20128/v1`
  (only needed for the opencode provider template)
- Background images for WezTerm in `C:\Users\JSlaig\Pictures\terminal`
  (`.jpg`, `.jpeg`, `.png`, `.webp`)

## Install

On a fresh machine:

```powershell
winget install chezmoi
chezmoi init --apply https://github.com/JSlaig/dotfiles-win.git
```

`chezmoi init --apply` clones the repo, creates the chezmoi config, and applies
all files to your home directory.

The opencode config is generated from `opencode.json.tmpl`, which reads the
`omniroute_api_key` value. Set it in your chezmoi config data
(`~/.config/chezmoi/chezmoi.toml`) before applying:

```toml
[data]
  omniroute_api_key = "your-omniroute-key"
```

### Pulling the nvim external

The nvim config is an external git-repo source, so it isn't part of the initial
apply. Fetch it with:

```powershell
chezmoi update   # or: chezmoi apply --include externals
```

## Updating / making changes

Dotfiles live in the repo, not on your machine. To change something:

1. Edit the checked-in file directly, then `chezmoi apply` to push it live, or
2. Edit the live file and re-import the change:

```powershell
chezmoi add $env:USERPROFILE\.config\opencode\tui.jsonc   # record an edit
chezmoi diff                                              # preview what will change
chezmoi apply                                             # apply to the live machine
```

Occasionally re-source the externals (nvim, Herdr/opencode plugin updates):

```powershell
chezmoi update
```

## Per-app config notes

### WezTerm — `dot_wezterm.lua`

- 140x40 window with `RESIZE` decorations only; tab bar is **off**.
- Picks a random wallpaper from `C:\Users\JSlaig\Pictures\terminal` and dims it
  to 25% brightness. Logs an error if the folder is empty.
- Default shell is `powershell.exe`; `Ctrl-v` pastes from the clipboard.
- **Change the hardcoded path**: if your wallpaper folder differs, edit the
  `wallpaper_dir` variable at the top of the file.

### Herdr — `AppData/Roaming/herdr/config.toml`

- Prefix is `Alt+\` (a chord is required on Windows; bare Alt is reserved).
- `Prefix+b` toggles sidebar, `Prefix+w` workspace picker,
  `Prefix+,` / `Prefix+.` cycle workspaces, `Prefix+p` / `Prefix+n` cycle tabs,
  `Prefix+Tab` jumps between the last two panes.
- Theme is `kanagawa`, toasts render in the terminal, onboarding is off.

### opencode — `dot_config/opencode/`

- `opencode.json.tmpl` generates `opencode.json` with the **OmniRoute**
  provider (`omniroute/auto` and `auto/fast`, `auto/cheap`, `auto/coding`)
  pointing at `http://pi.lan:20128/v1`.
- `opencode.jsonc` sets the default shell to PowerShell (this file is committed
  directly, not templated).
- `tui.jsonc` loads the `herdr-tui-session.js` plugin, and
  `plugins/herdr-agent-state.js` reports agent states back to Herdr.
  These plugin files are **managed by Herdr** — don't edit them by hand; drop
  extra plugins beside them instead.

## Troubleshooting

- **No wallpaper / black background** — check `C:\Users\JSlaig\Pictures\terminal`
  exists and has images; WezTerm logs the error to its debug output.
- **Fonts look wrong** — install the JetBrainsMono Nerd Font family and restart
  WezTerm.
- **`omniroute_api_key` not set** — opencode apply step errors when the
  template can't find the value; add it to `~/.config/chezmoi/chezmoi.toml`
  under `[data]`.
- **nvim keybindings missing** — the nvim external hasn't been fetched; run
  `chezmoi update`.