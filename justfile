# ClaudeOS — Ubuntu 24.04 + Hyprland + Nix Home Manager

# Default: show available commands
default:
    @just --list

# Apply Home Manager configuration for current host
switch:
    home-manager switch --flake ~/Projects/claudeos#tom@$(hostname)

# Update flake inputs
update:
    nix flake update --flake ~/Projects/claudeos

# Update and switch in one step
upgrade: update switch

# Check flake for errors
check:
    nix flake check --flake ~/Projects/claudeos

# Format all Nix files
fmt:
    nix fmt ~/Projects/claudeos

# Apply system-manager configuration (requires sudo)
system:
    sudo $(nix build ~/Projects/claudeos#systemConfigs.default --print-out-paths --no-link)/activate

# Show diff of what would change
diff:
    home-manager switch --flake ~/Projects/claudeos#tom@$(hostname) -- --dry-run

# Install Claude Code CLI (official installer, self-updates)
install-claude:
    curl -fsSL https://claude.ai/install.sh | bash

# Install Claude Desktop (via apt repo, auto-updates with apt upgrade)
install-claude-desktop:
    curl -fsSL https://aaddrick.github.io/claude-desktop-debian/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/claude-desktop.gpg
    echo "deb [signed-by=/usr/share/keyrings/claude-desktop.gpg arch=amd64,arm64] https://aaddrick.github.io/claude-desktop-debian stable main" | sudo tee /etc/apt/sources.list.d/claude-desktop.list
    sudo apt update && sudo apt install -y claude-desktop

# Install bun runtime
install-bun:
    curl -fsSL https://bun.sh/install | bash

# Install uv (Python package manager)
install-uv:
    curl -LsSf https://astral.sh/uv/install.sh | sh

# Full bootstrap (run on fresh Ubuntu install)
bootstrap:
    bash ~/Projects/claudeos/bootstrap.sh
