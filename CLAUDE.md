# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a flake-based NixOS and nix-darwin configuration repository managing multiple machines (both Linux and macOS). The repository uses a custom modular system with the `kdlt` namespace for configuration options.

## System Architecture

### Flake Structure (flake.nix:49-152)

The flake defines configurations for:
- **Darwin systems**: K-MBP (Apple Silicon MacBook Pro)
- **NixOS systems**:
  - Super (5700X3D + RTX 4080 Super desktop)
  - Link (Beelink Mini PC)
  - Think (Lenovo ThinkPad T480)

### Key Inputs
- `nixpkgs` (unstable channel) and `nixpkgs-stable` (24.05)
- `home-manager` for user environment management
- `nix-darwin` for macOS configurations
- `nixvim` - currently pointing to local path at `/Users/kba/github/KDLT/nixvim` for testing
- `hyprland` + `hyprlock` for Wayland compositing
- `sops-nix` for secrets management
- `impermanence` for ephemeral root filesystem
- `disko` for declarative disk partitioning
- `stylix` for system-wide theming

### Module System

The repository uses a custom `scanPaths` function (lib/default.nix:4-14) that automatically imports all `.nix` files and directories from a given path (excluding `default.nix`).

**Module Structure:**
```
modules/
├── base/          # Shared across NixOS and Darwin
│   ├── system.nix # Common system packages and environment variables
│   └── home-manager.nix
├── nixos/         # Linux-specific modules
│   ├── core/      # System fundamentals (shells, nix, connectivity, utils)
│   ├── storage/   # Filesystem configs (btrfs, zfs, nfs, samba)
│   ├── graphical/ # Desktop environment (hyprland, waybar, applications)
│   └── development/ # Development tools and language servers
└── darwin/        # macOS-specific modules
    ├── home/      # Home-manager configs (nixvim, zsh, git, kitty, aerospace)
    ├── system/    # macOS system settings
    ├── homebrew/  # Homebrew packages
    └── development/ # Development tools
```

**Machine Configs:**
- Located in `machines/<hostname>/default.nix`
- Each machine imports appropriate module sets via `darwinModules` or `nixosModules`
- Machine configs set hostname, hardware, and enable/configure features via `kdlt.*` options

### Custom Options Namespace

All custom options use the `kdlt` namespace. Key top-level options:
- `kdlt.stateVersion` - System state version
- `kdlt.core.laptop` - Enable laptop-specific configs
- `kdlt.core.server` - Enable server mode
- `kdlt.core.nixvim.enable` - Enable custom nixvim configuration
- `kdlt.storage.{btrfs,zfs}.enable` - Filesystem selection
- `kdlt.storage.{dataPrefix,cachePrefix}` - Persistent data paths (for impermanence)
- `kdlt.graphical.enable` - Enable graphical environment
- `kdlt.graphical.wallpaper` - Wallpaper path
- `kdlt.graphical.hyprland.display` - Monitor configuration
- `kdlt.graphical.nvidia.{enable,super}` - NVIDIA GPU settings

### Special Args

All modules receive `specialArgs` (flake.nix:89-99):
- `username` = "kba"
- `useremail` = "aguirrekenneth@gmail.com"
- `userfullname` = "Kenneth B. Aguirre"
- `stateVersion` = "24.05"
- `mylib` - Custom library with `scanPaths` function
- `inputs` and `outputs` - Flake inputs and outputs

## Common Commands

### Building Configurations

**NixOS (on Linux machines):**
```bash
sudo nixos-rebuild switch --flake .#<hostname>
# Examples:
sudo nixos-rebuild switch --flake .#Super
sudo nixos-rebuild switch --flake .#Link
sudo nixos-rebuild switch --flake .#Think
```

**nix-darwin (on macOS):**
```bash
darwin-rebuild switch --flake .#K-MBP
```

### Testing Configurations

**NixOS:**
```bash
sudo nixos-rebuild test --flake .#<hostname>
```

**nix-darwin:**
```bash
darwin-rebuild check --flake .#K-MBP
```

### Updating Dependencies

```bash
# Update all inputs
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager
```

### Flake Management

```bash
# Check flake for errors
nix flake check

# Show flake metadata
nix flake metadata

# Show flake outputs
nix flake show
```

### Secrets Management (SOPS)

The repository uses sops-nix with configuration in `.sops.yaml`. Secrets should be encrypted before committing.

## Development Workflow

### Adding New Modules

1. Create module in appropriate directory (`modules/nixos/`, `modules/darwin/`, or `modules/base/`)
2. Define options under `kdlt.*` namespace using `mkOption` or `mkEnableOption`
3. The `scanPaths` function will automatically import it
4. Enable in machine config via `kdlt.*` options

### Modifying Machine Configs

Edit `machines/<hostname>/default.nix` to configure machine-specific settings. Most configuration is done by setting `kdlt.*` options rather than directly setting NixOS/Darwin options.

### Working with nixvim

The repository uses a custom nixvim flake at `github:KDLT/nixvim` (flake.nix:31).

**To test local nixvim changes:**
1. Test modifications directly: `nix run ~/github/KDLT/nixvim/. <test-file>`
   - Where `<test-file>` is the relevant file type you're testing (e.g., a .js file for JavaScript LSP changes)
2. When satisfied, commit and push changes to remote nixvim repo
3. Update nixdots flake lock: `nix flake update nixvim` (run in nixdots directory)
4. Rebuild system to use updated nixvim: `darwin-rebuild switch --flake .#K-MBP`

## Important Notes

- **Base modules** (`modules/base/`) are shared between NixOS and Darwin - only add cross-platform compatible options here
- **State version** is pinned to "24.05" across all systems
- **Timezone** is set to "Asia/Manila" in base system config
- The repository uses impermanence on some systems - check `kdlt.storage.dataPrefix` and `cachePrefix` for persistent paths
- **Package management philosophy**:
  - Prefer Nix over homebrew for cross-platform tools (allows version pinning, rollback, and availability across all machines)
  - Cross-platform packages go in `modules/base/system.nix` (e.g., gh, wget, nodejs, bun, ffmpeg)
  - macOS-only utilities can stay in homebrew for better macOS integration (e.g., mas, m-cli, terminal-notifier)
  - Only add to `base/system.nix` if the package is truly needed across all systems
- **Kitty theming**: Uses `themeFile` from kitty-themes package with optional `background` color override in `settings` section
