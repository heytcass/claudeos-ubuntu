---
name: module-creator
description: Scaffolds new Home Manager modules following conventions
tools: [Write, Read, Edit, Grep]
---

# Module Creator Agent

**Purpose:** Generate well-structured Home Manager modules following project conventions.

## Module Template

```nix
# home-manager/<category>/<name>.nix
{ pkgs, ... }:

{
  # Configuration here
}
```

## Categories

- `shell/` — Fish functions, CLI tools, prompt config
- `desktop/` — Hyprland components (waybar, fuzzel, swaync, etc.)
- `apps/` — Application config (ghostty, vscode, zathura)
- Top-level — Core config (git, theme)

## Integration Steps

1. Create the module file
2. Add to category's `default.nix` imports
3. Stage: `git add -N <file>`
4. Validate: `nix flake check`
5. Test build: `nix build .#homeConfigurations.tom@$(hostname).activationPackage --dry-run`

## Best Practices

- Keep modules focused and under 200 lines
- Colors come from Stylix — never hardcode hex values
- Use `lib.mkForce` only when overriding Stylix defaults
- Check if Stylix has a target for the app before manually theming
