# ClaudeOS — Ubuntu 24.04 + Hyprland + Nix Home Manager

This is a Claude-native desktop environment running on Ubuntu 24.04 LTS with Nix Home Manager for declarative user configuration.

## Architecture

- **Base OS:** Ubuntu 24.04 LTS (minimal server install)
- **Desktop:** Hyprland (Wayland tiling compositor) + Waybar + Fuzzel + SwayNC
- **Theming:** Stylix with Claude brand base16 colors
- **Shell:** Fish + Starship + modern CLI tools
- **Terminal:** Ghostty
- **User config:** Nix Home Manager (standalone flake)
- **System config:** system-manager (numtide) for fonts, greetd, etc.
- **Claude tools:** Installed natively outside Nix (official installers, .deb, npm/pip). NOT managed by this repo.

## Workflow

1. **Edit** configuration in `~/Projects/claudeos`
2. **Stage** new files with `git add` (Nix flakes only see tracked files)
3. **Apply** with `just switch`
4. **Check** with `just check`
5. **Format** with `just fmt`
6. **Update** inputs with `just update`

## Key Directories

```
flake.nix              # Entry point — HM + system-manager configs
lib/                   # Helpers: mkHome, theme constants
home-manager/          # All Home Manager modules
  shell/               # Fish, CLI tools, Starship
  desktop/             # Hyprland, Waybar, Fuzzel, SwayNC, Hyprlock, Hyprpaper
  apps/                # Ghostty, VS Code, Zathura
  git.nix              # Git + Delta
  theme.nix            # Stylix base16 scheme + fonts
system-manager/        # System-level config (fonts, greetd)
hosts/                 # Per-host overrides (display, scaling)
scripts/               # MCP servers, helper scripts
assets/                # Wallpaper, avatar
justfile               # Workflow commands
bootstrap.sh           # Fresh Ubuntu setup script
```

## Native Tools (installed by bootstrap.sh, NOT managed by Nix/HM)

Claude tools are installed via their official channels so they auto-update without
touching the Nix config. `bootstrap.sh` and `justfile` handle installation.
Do NOT add Nix packages, Home Manager modules, or config file generation for these.

- **Claude Code:** `~/.local/bin/claude` — official installer, self-updates
- **Claude Desktop:** apt repo from `aaddrick/claude-desktop-debian`, updates via `apt upgrade`
- **MCP servers:** `npm install -g` or `npx` — just install them
- **bun, uv, node/npm:** Official installers

## Theming

Uses Stylix with Claude brand base16 palette. Never hardcode hex colors — use `config.lib.stylix.colors` references. The scheme is defined in `home-manager/theme.nix`.

## Hosts

Multi-host flake. Use `$(hostname)` in commands. Hosts defined in `hosts/` and `flake.nix`.
- **gti:** Dell XPS 13 9370 (1.25x scaling)
- **transporter:** Dell Latitude 7280 (1.0x scaling)
