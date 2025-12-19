# nixdots

KDLT's flake-based NixOS and nix-darwin configuration repository managing multiple machines across Linux and macOS.

## Table of Contents

- [Machines](#machines)
- [Repository Structure](#repository-structure)
- [Quick Start](#quick-start)
- [Common Commands](#common-commands)
- [Configuration Guide](#configuration-guide)
- [Development Workflow](#development-workflow)
- [Troubleshooting](#troubleshooting)

---

## Machines

### Darwin (macOS)
- **K-MBP** - Apple Silicon MacBook Pro (aarch64-darwin)
  - Custom nixvim configuration
  - Homebrew integration for macOS-specific apps
  - Aerospace window manager
  - Kitty terminal with custom configs

### NixOS (Linux)

- **Super** - Desktop Workstation
  - CPU: AMD Ryzen 7 5700X3D
  - GPU: NVIDIA RTX 4080 Super
  - Display: 4K @ 120Hz (3840x2160)
  - Filesystem: Btrfs
  - Hyprland compositor with NVIDIA patches

- **Think** - Lenovo ThinkPad T480
  - Laptop + Server hybrid mode
  - Display: 1920x1080 @ 60Hz (native) / 4K @ 30Hz (HDMI)
  - Filesystem: ZFS with impermanence (ephemeral root)
  - ZFS pool: `rpool` (datasets: `persist/data`, `local/cache`)
  - Services: NFS, Samba, Docker, Tailscale, Plex
  - Stylix theming enabled

- **Link** - Beelink Mini PC
  - Compact server/workstation
  - Similar configuration to Think

---

## Repository Structure

```
nixdots/
├── flake.nix              # Main flake configuration
├── flake.lock             # Locked dependency versions
├── CLAUDE.md              # AI assistant context & guidelines
├── README.md              # This file
│
├── lib/
│   └── default.nix        # Custom library (scanPaths function)
│
├── machines/              # Per-machine configurations
│   ├── MBP/               # MacBook Pro (Darwin)
│   ├── Super/             # Desktop (NixOS)
│   ├── Think/             # ThinkPad (NixOS)
│   └── Link/              # Beelink (NixOS)
│       ├── default.nix    # Machine-specific kdlt.* options
│       └── hardware.nix   # Hardware configuration
│
├── modules/
│   ├── base/              # Shared across NixOS and Darwin
│   │   ├── system.nix     # Common packages & env vars
│   │   └── home-manager.nix
│   │
│   ├── darwin/            # macOS-specific modules
│   │   ├── home/          # Home-manager configs
│   │   │   ├── nixvim.nix
│   │   │   ├── zsh.nix
│   │   │   ├── git.nix
│   │   │   ├── kitty.nix
│   │   │   ├── aerospace/ # Window manager
│   │   │   ├── tmux.nix
│   │   │   └── yazi.nix
│   │   ├── homebrew/      # Homebrew packages
│   │   ├── system/        # macOS system settings
│   │   └── development/   # Dev tools
│   │
│   └── nixos/             # Linux-specific modules
│       ├── core/          # System fundamentals
│       │   ├── shells/    # ZSH, Fish, etc.
│       │   ├── nix/       # Nix daemon settings
│       │   ├── connectivity/ # NetworkManager, etc.
│       │   ├── utils/     # tmux, fzf, ripgrep, etc.
│       │   ├── users/     # User account management
│       │   ├── sops/      # Secrets management
│       │   └── nixvim/    # Neovim configuration
│       │
│       ├── storage/       # Filesystem configs
│       │   ├── btrfs/     # Btrfs configuration
│       │   ├── zfs/       # ZFS configuration
│       │   ├── impermanence/ # Ephemeral root setup
│       │   └── share/     # NFS, Samba
│       │
│       ├── graphical/     # Desktop environment
│       │   ├── desktop/   # Hyprland, Waybar, etc.
│       │   ├── applications/ # GUI apps
│       │   ├── nvidia/    # NVIDIA GPU settings
│       │   ├── amd/       # AMD GPU settings
│       │   ├── gtk/       # GTK theming
│       │   ├── stylix/    # System-wide theming
│       │   ├── terminal/  # Terminal emulators
│       │   └── xdg/       # XDG directories
│       │
│       └── development/   # Development tools
│           ├── git/
│           ├── nodejs/
│           ├── python/
│           ├── go/
│           ├── ansible/
│           ├── virtualization/ # Docker, Podman
│           └── tailscale/
│
└── assets/
    └── wallpaper-*.png    # Wallpapers
```

### Module System

All modules are automatically imported using the `scanPaths` function (lib/default.nix:4-14), which recursively imports all `.nix` files and directories (excluding `default.nix`).

**Custom Options Namespace: `kdlt`**

All configuration options use the `kdlt.*` namespace to avoid conflicts with base NixOS/Darwin options.

---

## Quick Start

### First Time Setup

**On NixOS:**
```bash
# Clone the repository
git clone https://github.com/KDLT/nixdots.git ~/nixdots
cd ~/nixdots

# Build and activate (replace <hostname> with your machine)
sudo nixos-rebuild switch --flake .#<hostname>
```

**On macOS (nix-darwin):**
```bash
# Clone the repository
git clone https://github.com/KDLT/nixdots.git ~/nixdots
cd ~/nixdots

# Build and activate
darwin-rebuild switch --flake .#K-MBP
```

---

## Common Commands

### Building Configurations

**NixOS (requires sudo):**
```bash
# Build and activate immediately
sudo nixos-rebuild switch --flake .#Super
sudo nixos-rebuild switch --flake .#Think
sudo nixos-rebuild switch --flake .#Link

# Build without activating (test first)
sudo nixos-rebuild test --flake .#Super

# Build and add to boot menu (activate on next reboot)
sudo nixos-rebuild boot --flake .#Super

# Dry run (show what would change)
sudo nixos-rebuild dry-run --flake .#Super

# Build without switching (useful for testing)
sudo nixos-rebuild build --flake .#Super
```

**macOS (nix-darwin):**
```bash
# Build and activate
darwin-rebuild switch --flake .#K-MBP

# Check for errors without building
darwin-rebuild check --flake .#K-MBP

# Dry run
darwin-rebuild build --flake .#K-MBP
```

### Flake Management

```bash
# Update all inputs (nixpkgs, home-manager, etc.)
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs
nix flake lock --update-input home-manager
nix flake lock --update-input nixvim
nix flake lock --update-input hyprland

# Check flake for errors
nix flake check

# Show flake metadata
nix flake metadata

# Show flake outputs (list all configurations)
nix flake show

# Show flake inputs and their versions
nix flake metadata --json | jq '.locks.nodes'
```

### Garbage Collection

```bash
# Delete old generations (NixOS)
sudo nix-collect-garbage --delete-older-than 7d

# Delete old generations (macOS)
nix-collect-garbage --delete-older-than 7d

# Optimize nix store (deduplicate)
nix-store --optimize

# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
```

### Searching Packages

```bash
# Search for a package in nixpkgs
nix search nixpkgs <package-name>

# Example: search for firefox
nix search nixpkgs firefox

# Show package details
nix search nixpkgs firefox --json | jq

# Search in flake registry
nix search nixpkgs#<package>
```

### Development Shell

```bash
# Enter a development shell with packages
nix shell nixpkgs#nodejs nixpkgs#python3

# Run a command in a temporary environment
nix run nixpkgs#cowsay -- "Hello NixOS"

# Develop with flake.nix devShell
nix develop
```

---

## Configuration Guide

### Key Options in `kdlt` Namespace

#### Core Options
```nix
kdlt = {
  username = "kba";
  fullname = "Kenneth Balboa Aguirre";
  email = "aguirrekenneth@gmail.com";
  stateVersion = "24.05";  # DO NOT CHANGE after initial install

  core = {
    laptop = true;          # Enable laptop-specific configs
    server = true;          # Enable server mode
    wireless.enable = true; # NetworkManager + wireless
    nixvim.enable = true;   # Custom nixvim configuration
    nix = {
      unfreePackages = [];  # List of unfree packages to allow
    };
  };
};
```

#### Storage Options
```nix
kdlt.storage = {
  # Btrfs (choose one filesystem)
  btrfs.enable = true;

  # OR ZFS
  zfs = {
    enable = true;
    zpool = {
      name = "rpool";
      dataset = {
        cache = "local/cache";   # Temporary data
        data = "persist/data";   # Persistent data
      };
    };
  };

  # Impermanence (ephemeral root filesystem)
  impermanence.enable = true;
  dataPrefix = "/data";          # Where persistent data lives
  cachePrefix = "/cache";        # Where cache lives

  # Network shares
  share.nfs.enable = true;
  share.samba.enable = true;
};
```

#### Graphical Options
```nix
kdlt.graphical = {
  enable = true;
  sound = true;
  laptop = false;  # Set true for laptop displays
  wallpaper = ../../assets/wallpaper-green.png;

  # NVIDIA GPU
  nvidia = {
    enable = true;
    super = true;  # For RTX 40-series
  };

  # System-wide theming
  stylix.enable = true;

  # Hyprland compositor
  hyprland = {
    enable = true;
    # Get display info: hyprctl monitors
    display = "HDMI-A-1, 3840x2160@119.88, 0x0, 1";
  };

  xdg.enable = true;  # XDG directories
};
```

#### Font Options
```nix
kdlt.nerdfont = {
  enable = true;
  # Font name reference:
  # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/shas.nix
  monospace.name = "CommitMono";
  serif.name = "Go-Mono";
  sansSerif.name = "JetBrainsMono";
  emoji.name = "Noto-Emoji";
};
```

#### Development Options
```nix
kdlt.development = {
  tailscale.enable = true;
  virtualization = {
    docker.enable = true;
    podman.enable = true;
  };
  git.enable = true;
  nodejs.enable = true;
  python.enable = true;
  go.enable = true;
  ansible.enable = true;
  aws-cli.enable = true;
  azure-cli.enable = true;
};
```

---

## Development Workflow

### Adding a New Module

1. **Create the module file** in the appropriate directory:
   ```bash
   # For NixOS modules
   touch modules/nixos/development/rust/default.nix

   # For Darwin modules
   touch modules/darwin/development/rust.nix
   ```

2. **Define options under `kdlt.*` namespace:**
   ```nix
   { lib, config, pkgs, ... }:
   {
     options.kdlt.development.rust = {
       enable = lib.mkEnableOption "Rust development tools";
     };

     config = lib.mkIf config.kdlt.development.rust.enable {
       environment.systemPackages = with pkgs; [
         rustc
         cargo
         rust-analyzer
       ];
     };
   }
   ```

3. **Enable in machine config** (`machines/<hostname>/default.nix`):
   ```nix
   kdlt.development.rust.enable = true;
   ```

4. **Rebuild:**
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   ```

The `scanPaths` function automatically imports your new module - no manual imports needed!

### Modifying Existing Configurations

1. **Edit the relevant module or machine config**
2. **Test the changes:**
   ```bash
   # NixOS: test without adding to boot menu
   sudo nixos-rebuild test --flake .#<hostname>

   # macOS: build without activating
   darwin-rebuild build --flake .#K-MBP
   ```
3. **If tests pass, activate:**
   ```bash
   sudo nixos-rebuild switch --flake .#<hostname>
   # or
   darwin-rebuild switch --flake .#K-MBP
   ```

### Working with nixvim

The repository uses a custom nixvim flake at `github:KDLT/nixvim`.

**To test local nixvim changes:**
```nix
# In flake.nix, temporarily change:
nixvim.url = "github:KDLT/nixvim";
# to:
nixvim.url = "path:/path/to/local/nixvim";
```

**Update nixvim to latest:**
```bash
nix flake lock --update-input nixvim
darwin-rebuild switch --flake .#K-MBP
```

**Switch back to remote after testing:**
```nix
nixvim.url = "github:KDLT/nixvim";
```
Then update the lock file:
```bash
nix flake lock --update-input nixvim
```

---

## Secrets Management (SOPS)

The repository uses `sops-nix` for secrets management (configuration in `.sops.yaml`).

### Encrypting Secrets

```bash
# Edit encrypted file (creates if doesn't exist)
sops secrets/secrets.yaml

# Encrypt a new file
sops -e secrets/new-secret.yaml > secrets/new-secret.enc.yaml
```

### Using Secrets in Configuration

```nix
{
  # Define the secret
  sops.secrets.example-secret = {
    sopsFile = ./secrets/secrets.yaml;
  };

  # Use it (available at /run/secrets/example-secret)
  services.someService.passwordFile = config.sops.secrets.example-secret.path;
}
```

**Important:** Always encrypt secrets before committing!

---

## Troubleshooting

### Build Fails

```bash
# Check for errors in flake
nix flake check

# Build with verbose output
sudo nixos-rebuild switch --flake .#<hostname> --show-trace

# Check specific module
nix-instantiate --eval -E '(import <nixpkgs> {}).lib.evalModules { modules = [ ./modules/path/to/module.nix ]; }'
```

### Rollback to Previous Generation

```bash
# NixOS: List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Rollback to specific generation
sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation <number>

# macOS: Rollback
darwin-rebuild --rollback
```

### Flake Update Issues

```bash
# If update breaks something, rollback flake.lock
git restore flake.lock

# Update only specific inputs one at a time
nix flake lock --update-input nixpkgs
# Test
sudo nixos-rebuild test --flake .#<hostname>
# If good, commit; if bad, git restore flake.lock
```

### Hyprland Display Issues

```bash
# Get monitor info
hyprctl monitors

# Test display configuration
# Edit kdlt.graphical.hyprland.display in machine config
# Format: "NAME, WIDTHxHEIGHT@REFRESH, XxY, SCALE"
# Example: "HDMI-A-1, 3840x2160@119.88, 0x0, 1"
```

### ZFS Pool Not Found

```bash
# Import pool manually
sudo zpool import -f rpool

# Check pool status
zpool status

# If pool corrupted, try recovery
sudo zpool import -F rpool
```

### Impermanence: Files Disappear After Reboot

Impermanence wipes root on every boot. Persistent files must be declared:

```nix
kdlt.storage.impermanence = {
  enable = true;
  # Add to the impermanence module configuration
};

# Or add files in modules/nixos/storage/impermanence/default.nix
environment.persistence."/data" = {
  directories = [
    "/var/lib/new-service"
  ];
  files = [
    "/etc/machine-id"
  ];
};
```

### Homebrew Installation Issues (macOS)

```bash
# Rebuild will automatically install/update homebrew packages
darwin-rebuild switch --flake .#K-MBP

# Manually update homebrew
brew update && brew upgrade

# If homebrew breaks, reinstall
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## Special Args

All modules receive these `specialArgs` (defined in flake.nix:89-99):

- `username` = "kba"
- `useremail` = "aguirrekenneth@gmail.com"
- `userfullname` = "Kenneth B. Aguirre"
- `stateVersion` = "24.05"
- `mylib` - Custom library with `scanPaths` function
- `inputs` - All flake inputs
- `outputs` - All flake outputs

---

## Important Notes

- **State Version:** Set once during initial install, DO NOT change later
- **Base Modules:** Only add cross-platform compatible code to `modules/base/`
- **Timezone:** Hardcoded to "Asia/Manila" in base system config
- **Impermanence:** Check `kdlt.storage.dataPrefix` and `cachePrefix` for persistent paths
- **Package Additions:** Prefer adding to module-specific configs, not base `system.nix` unless truly universal
- **Git Dirty State:** Flake commands warn if working tree is dirty - commit or stash changes

---

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Package Search](https://search.nixos.org/packages)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.xhtml)
- [Nix Darwin Options](https://daiderd.com/nix-darwin/manual/index.html)
- [Hyprland Wiki](https://wiki.hyprland.org/)
- [KDLT's nixvim](https://github.com/KDLT/nixvim)

---

**Maintained by:** Kenneth B. Aguirre (aguirrekenneth@gmail.com)
