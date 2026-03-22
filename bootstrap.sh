#!/usr/bin/env bash
set -euo pipefail

# ClaudeOS Bootstrap — Run on a fresh Ubuntu 24.04 LTS minimal install
# Usage: bash bootstrap.sh

RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[34m'
BOLD='\033[1m'
RESET='\033[0m'

info() { echo -e "${BLUE}${BOLD}[INFO]${RESET} $*"; }
success() { echo -e "${GREEN}${BOLD}[OK]${RESET} $*"; }
error() { echo -e "${RED}${BOLD}[ERROR]${RESET} $*"; exit 1; }

# ── Preflight checks ──────────────────────────────────────
[[ -f /etc/os-release ]] || error "/etc/os-release not found"
source /etc/os-release
[[ "${ID:-}" == "ubuntu" ]] || error "This script is for Ubuntu (detected: ${ID:-unknown})"
[[ "${EUID:-$(id -u)}" -ne 0 ]] || error "Do not run as root"
[[ -z "${SUDO_USER:-}" ]] || error "Do not run with sudo"

info "Requesting sudo access..."
sudo -v || error "Failed to get sudo"

# ── System packages ────────────────────────────────────────
info "Installing system packages..."
sudo apt update
sudo apt install -y \
    fish \
    build-essential \
    curl \
    git \
    pipewire pipewire-pulse pipewire-alsa wireplumber \
    bluez \
    ufw \
    brightnessctl \
    thermald \
    power-profiles-daemon \
    xdg-desktop-portal-gtk \
    polkit-gnome \
    gnome-keyring \
    nautilus \
    network-manager

# Change default shell to fish
if [[ "$(getent passwd "$USER" | cut -d: -f7)" != */fish ]]; then
    info "Setting fish as default shell..."
    sudo chsh -s "$(which fish)" "$USER"
fi

# Firewall
info "Configuring firewall..."
sudo ufw --force enable
sudo ufw default deny incoming
sudo ufw allow ssh

# ── Determinate Nix ────────────────────────────────────────
if ! command -v nix &>/dev/null; then
    info "Installing Determinate Nix..."
    curl -sSfL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif ! nix --version 2>/dev/null | grep -q "Determinate"; then
    info "Upgrading to Determinate Nix..."
    curl -sSfL https://install.determinate.systems/nix | sh -s -- install --determinate --no-confirm
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
    success "Determinate Nix already installed"
fi

# ── Home Manager ───────────────────────────────────────────
info "Running Home Manager switch..."
nix run home-manager -- switch --flake ~/Projects/claudeos#"tom@$(hostname)"
success "Home Manager applied"

# ── Claude tools (official installers — NOT managed by Nix) ─
# Claude Code CLI
if [[ ! -f "$HOME/.local/bin/claude" ]]; then
    info "Installing Claude Code CLI..."
    curl -fsSL https://claude.ai/install.sh | bash
    success "Claude Code installed"
else
    success "Claude Code already installed"
fi

# Claude Desktop (via aaddrick/claude-desktop-debian apt repo)
if ! command -v claude-desktop &>/dev/null; then
    info "Installing Claude Desktop..."
    curl -fsSL https://aaddrick.github.io/claude-desktop-debian/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/claude-desktop.gpg
    echo "deb [signed-by=/usr/share/keyrings/claude-desktop.gpg arch=amd64,arm64] https://aaddrick.github.io/claude-desktop-debian stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list
    sudo apt update
    sudo apt install -y claude-desktop
    success "Claude Desktop installed"
else
    success "Claude Desktop already installed"
fi

# ── Developer tools (official installers) ──────────────────
# bun
if ! command -v bun &>/dev/null; then
    info "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    success "bun installed"
else
    success "bun already installed"
fi

# uv
if ! command -v uv &>/dev/null; then
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    success "uv installed"
else
    success "uv already installed"
fi

# Node.js
if ! command -v node &>/dev/null; then
    info "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo bash -
    sudo apt install -y nodejs
    success "Node.js installed"
else
    success "Node.js already installed"
fi

echo ""
success "Bootstrap complete!"
echo ""
info "Next steps:"
echo "  1. Log out and back in (fish shell + Nix PATH)"
echo "  2. Start Hyprland from your display manager or TTY"
echo "  3. Run 'claude' to start Claude Code"
echo "  4. Run 'claude-desktop' or press Ctrl+Alt+Space for Claude Desktop"
echo ""
info "Workflow commands (run from ~/Projects/claudeos):"
echo "  just switch    — apply config changes"
echo "  just update    — update flake inputs"
echo "  just upgrade   — update + switch"
echo "  just check     — validate flake"
