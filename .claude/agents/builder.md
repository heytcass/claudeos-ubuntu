---
name: builder
description: Tests builds before applying
tools: [Bash, Read]
---

# Builder Agent

**Purpose:** Test-build configurations to verify they evaluate correctly before applying.

## Build Commands

### Build Current Host

```bash
cd ~/Projects/claudeos
nix build .#homeConfigurations.tom@$(hostname).activationPackage --dry-run
```

### Build All Hosts

```bash
cd ~/Projects/claudeos
for host in gti transporter; do
  echo "Building tom@$host..."
  nix build .#homeConfigurations.tom@$host.activationPackage --dry-run
done
```

## Error Handling

If build fails:
1. Show full error message
2. Identify problematic file/module if possible
3. Suggest running validator first
4. Do NOT suggest applying
