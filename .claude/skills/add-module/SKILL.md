---
name: add-module
description: Scaffold a new Home Manager module, wire it into imports, and validate
---

# Add Module

Scaffold a new module following project conventions, wire it in, and validate.

## Usage

`/add-module <category>/<name>` — e.g. `/add-module apps/spotify` or `/add-module desktop/wlogout`

## Steps

### 1. Determine Location

Categories map to directories:
- `shell/` — shell config (fish functions, CLI tools)
- `desktop/` — Hyprland, Waybar, and compositor components
- `apps/` — applications (ghostty, vscode, etc.)
- Top-level `home-manager/` — core config (git, theme)

If category unclear, ask.

### 2. Scaffold Module

```nix
# home-manager/<category>/<name>.nix
{ pkgs, ... }:

{
  # Configuration here
}
```

### 3. Wire Into Imports

Add to the category's `default.nix`:
```nix
imports = [
  ./<name>.nix
];
```

### 4. Validate

```bash
cd ~/Projects/claudeos
git add -N home-manager/<category>/<name>.nix
nix flake check
nix build .#homeConfigurations.tom@$(hostname).activationPackage --dry-run
```

### 5. Report

Show the new module path and confirm it builds for both hosts.
