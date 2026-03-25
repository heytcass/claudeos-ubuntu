---
name: deploy
description: Validate, build, and deploy Home Manager configuration
---

# Deploy Configuration

Full deployment pipeline: validate → build → apply.

## Usage

`/deploy` or `/deploy <hostname>`

## Steps

### 1. Determine Target

If no host specified, default to `$(hostname)` (current machine). List available hosts from `hosts/` directory.

### 2. Stage New Files

Nix flakes only see tracked files:
```bash
git -C ~/Projects/claudeos add -N $(git -C ~/Projects/claudeos ls-files --others --exclude-standard)
```

### 3. Validate

```bash
cd ~/Projects/claudeos
nix flake check
nix fmt -- --check .
```

**Stop on failure.** Fix before continuing.

### 4. Build (dry-run)

```bash
nix build .#homeConfigurations.tom@<host>.activationPackage --dry-run
```

**Stop on failure.** Do not proceed to apply.

### 5. Apply

```bash
home-manager switch --flake ~/Projects/claudeos#tom@<host>
```

Or equivalently: `just switch`

### 6. Verify

Report success and ask user to verify target functionality works. If system-manager changes were also made:
```bash
just system
```
