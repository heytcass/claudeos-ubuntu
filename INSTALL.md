# ClaudeOS Install Guide

Ubuntu 24.04 LTS + Hyprland + Nix Home Manager. From bare metal to a working Claude-native desktop.

## Requirements

- A machine (Dell XPS 13 9370 "gti" or Dell Latitude 7280 "transporter", or adapt `hosts/` for your hardware)
- A USB drive (4GB+) for the Ubuntu installer
- Internet connection
- ~30 minutes

## Step 1: Create Ubuntu Installer

On any existing machine, download Ubuntu Server 24.04 LTS (minimal):

```
https://ubuntu.com/download/server
```

Flash to USB with your tool of choice (Balena Etcher, `dd`, Ventoy, etc.):

```bash
# Example with dd (replace /dev/sdX with your USB device)
sudo dd if=ubuntu-24.04-live-server-amd64.iso of=/dev/sdX bs=4M status=progress
```

## Step 2: Install Ubuntu

Boot from USB and run the installer:

1. **Language:** English
2. **Keyboard:** US (the Colemak layout is handled by Hyprland, not the console)
3. **Install type:** Ubuntu Server (minimized)
4. **Network:** Connect to WiFi or Ethernet — needed for package downloads
5. **Storage:**
   - Use the entire disk
   - Filesystem: **ext4** is fine (simple), or **btrfs** if you want snapshots later
   - No need for complex partitioning — Ubuntu defaults are good
6. **Profile:**
   - Your name: `Tom Cassady`
   - Server name: `gti` (or `transporter` — must match a hostname in `hosts/`)
   - Username: `tom`
   - Password: your choice
7. **SSH:** Enable OpenSSH server (useful for remote setup)
8. **Snaps:** Skip all optional snaps

Let the installer finish and reboot. Remove the USB drive.

## Step 3: First Boot

You'll land at a TTY login prompt (no graphical desktop yet — that comes from Hyprland via Nix).

Log in as `tom`, then:

```bash
# Verify you're online
ping -c 1 google.com

# Install git and curl (may already be present)
sudo apt update && sudo apt install -y git curl
```

## Step 4: Clone the Repo

```bash
mkdir -p ~/Projects
git clone https://github.com/heytcass/claudeos-ubuntu ~/Projects/claudeos
```

## Step 5: Run Bootstrap

The bootstrap script installs everything: system packages, Determinate Nix, Home Manager config, Claude Code, Claude Desktop, bun, uv, and Node.js.

```bash
bash ~/Projects/claudeos/bootstrap.sh
```

This takes 10-20 minutes depending on your connection. It will:

1. Install system packages via apt (PipeWire, NetworkManager, polkit, etc.)
2. Set Fish as your default shell
3. Configure the firewall (UFW)
4. Install Determinate Nix with flakes enabled
5. Run `home-manager switch` to install and configure:
   - Hyprland (compositor)
   - Waybar (status bar)
   - Fuzzel (app launcher)
   - SwayNC (notifications)
   - Hyprlock (lock screen)
   - Ghostty (terminal)
   - Fish + Starship + all CLI tools
   - VS Code
   - Stylix theming (Claude brand colors)
6. Install Claude Code via official installer
7. Install Claude Desktop via apt repo
8. Install bun, uv, Node.js via official installers

## Step 6: Start Hyprland

Log out and back in (or reboot) to pick up the new shell and Nix PATH:

```bash
# Option A: Start Hyprland directly from TTY
Hyprland

# Option B: If you want auto-start on login, add to ~/.profile:
echo '[ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ] && exec Hyprland' >> ~/.profile
```

> **Note:** If you want a graphical login manager (greetd/GDM) instead of TTY auto-start, that's a future enhancement via system-manager. For now, TTY login + auto-start is the simplest path.

## Step 7: Verify Everything Works

Once Hyprland is running:

| Check | How |
|-------|-----|
| Terminal | Press `Mod+Return` — Ghostty should open |
| App launcher | Press `Mod+D` — Fuzzel should appear |
| Claude Code | Press `Mod+C` — floating Claude terminal |
| Claude Desktop | Press `Ctrl+Alt+Space` — Claude Desktop window |
| Bar | Waybar should be visible at top with clock, battery, etc. |
| Theme | Dark mode, Claude brand colors (terracotta accent) |
| Audio | Click volume icon in Waybar or use media keys |
| Shell | Open Ghostty, you should see Fish + Starship prompt |
| CLI tools | Try `ls` (eza), `cat` (bat), `z` (zoxide) |

## Key Bindings Reference

These match your previous Niri muscle memory:

| Binding | Action |
|---------|--------|
| `Mod+Return` | Open Ghostty terminal |
| `Mod+C` | Claude Code (floating terminal) |
| `Ctrl+Alt+Space` | Claude Desktop |
| `Mod+D` | Fuzzel app launcher |
| `Mod+Q` | Close window |
| `Mod+F` | Maximize window |
| `Mod+Shift+F` | True fullscreen |
| `Mod+V` | Toggle floating |
| `Mod+Left/Right` | Focus left/right |
| `Mod+Up/Down` | Focus up/down |
| `Mod+Shift+Arrow` | Move window |
| `Mod+1-9` | Switch workspace |
| `Mod+Shift+1-9` | Move window to workspace |
| `Mod+L` | Lock screen |
| `Mod+Shift+C` | Clipboard history |
| `Print` | Screenshot (region) |
| `Mod+A` | Claude quick question |
| `Mod+Shift+A` | Claude screenshot analysis |

## Day-to-Day Workflow

### Updating your config

```bash
cd ~/Projects/claudeos
# Edit .nix files
just switch          # Apply changes
just check           # Validate flake
just fmt             # Format Nix files
git add -A && git commit && git push
```

### Updating everything

```bash
just upgrade         # Updates flake inputs + applies
sudo apt upgrade     # Updates Claude Desktop + system packages
```

### Installing new tools

Claude tools and MCP servers install natively — no Nix needed:

```bash
# New MCP server
npm install -g @anthropic-ai/some-mcp-server

# Or run one without installing
npx @anthropic-ai/some-mcp-server

# Python tool
uv tool install some-tool

# Claude Code updates itself automatically
claude update
```

### Shell functions

| Command | What it does |
|---------|-------------|
| `fix` | Claude suggests a fix for your last failed command |
| `explain` | Claude explains your last command, or pipe output to it |
| `ask "..."` | Quick Claude question inline |

## Troubleshooting

### Hyprland doesn't start

```bash
# Check if Hyprland binary is available
which Hyprland

# If not found, Nix PATH may not be loaded. Source it:
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
export PATH="$HOME/.nix-profile/bin:$PATH"
Hyprland
```

### No audio

```bash
# Check PipeWire is running
systemctl --user status pipewire wireplumber

# If not running:
systemctl --user start pipewire wireplumber
```

### Claude Code not found

```bash
# Check it's installed
ls ~/.local/bin/claude

# If missing, reinstall:
curl -fsSL https://claude.ai/install.sh | bash

# Make sure ~/.local/bin is in PATH
echo $PATH | grep -q '.local/bin' || fish_add_path ~/.local/bin
```

### Claude Desktop not found

```bash
# Check it's installed
which claude-desktop

# If missing, reinstall via apt:
sudo apt update && sudo apt install -y claude-desktop

# Run diagnostics
claude-desktop --doctor
```

### Fonts look wrong

```bash
# Rebuild font cache
fc-cache -fv

# Verify Nix fonts are visible
fc-list | grep "JetBrains"
```

### Home Manager switch fails

```bash
# Make sure all files are staged (flakes only see tracked files)
cd ~/Projects/claudeos
git add -A
just switch
```

## Second Machine

To set up the second machine (transporter), follow the same steps but:

1. Set hostname to `transporter` during Ubuntu install
2. Clone the same repo
3. Bootstrap will automatically use `hosts/transporter.nix` overrides

```bash
# On transporter:
git clone https://github.com/heytcass/claudeos-ubuntu ~/Projects/claudeos
bash ~/Projects/claudeos/bootstrap.sh
```
