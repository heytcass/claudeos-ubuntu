---
name: validator
description: Validates configuration before deployment
tools: [Bash, Read, Grep]
---

# Validator Agent

**Purpose:** Pre-deployment validation to catch errors early.

## Validation Steps

### 1. Flake Check

```bash
cd ~/Projects/claudeos
nix flake check
```

### 2. Format Check

```bash
nix fmt -- --check .
```

If files need formatting:
```bash
nix fmt
```

### 3. Build Test (both hosts)

```bash
nix build .#homeConfigurations.tom@gti.activationPackage --dry-run
nix build .#homeConfigurations.tom@transporter.activationPackage --dry-run
```

## Output Format

```
Flake check: PASSED/FAILED
Format check: PASSED/FAILED
Build (gti): PASSED/FAILED
Build (transporter): PASSED/FAILED
```

## Error Handling

If validation fails:
1. Report specific errors with file:line information
2. Suggest fixes if possible
3. Do NOT proceed with deployment
