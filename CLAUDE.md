# CLAUDE.md

Orientation for agents working in this repo. Read this first, then open only
the files the task needs.

- **Vocabulary**: `CONTEXT.md` (glossary: bundle, always-on layer, interface parity)
- **Why a choice was made**: `docs/adr/`
- **What each option does**: the module file that defines it (`grep -rl mkOption modules/`)

## What this is

Flake-based NixOS and nix-darwin config for several machines. Custom option
namespace `kdlt.*`. Modules are auto-imported by `scanPaths`
(`lib/default.nix`): every `.nix` file and directory under a path except
`default.nix`. No manual `imports` lists for feature modules.

## Machines (`machines/<host>/default.nix`)

| Flake attr | Kind | Notes |
|---|---|---|
| `K-MBP` | darwin | Apple Silicon MBP, main machine |
| `K-MBA` | darwin | MacBook Air. Nix via the Determinate installer, so `nix.enable = false` and GC is manual. Mostly headless. |
| `Think` | NixOS | ThinkPad T480, ZFS single + impermanence, Hyprland, Plex |
| `Link` | NixOS | Beelink, ZFS mirror, AMD, Hyprland |
| `Super` | NixOS | 5700X3D / RTX 4080S desktop. **Config is stale** — its own comment says follow Think/Link. |

A machine config sets identity + hardware and enables `kdlt.*` options and
(Darwin) bundles. It should not carry shared logic.

## Layout

```
modules/base/      shared NixOS + Darwin (only put cross-platform code here)
modules/nixos/     core/ storage/ graphical/ development/
modules/darwin/    always-on layer + bundles/ + networking/ (tailscale) + nix/
```

`modules/darwin` outside `bundles/` is the **always-on layer**: applied to
every Mac, no toggle. Anything that differs between Macs is a **bundle**
(`modules/darwin/bundles/<name>.nix`) gated by
`kdlt.darwin.bundles.<name>.enable` (default false). Current bundles:
interface, proton, creative, printing3d, chat, dev. See ADR 0001.

## specialArgs (all modules receive these)

`username` "kba", `useremail`, `userfullname`, `stateVersion` "24.05",
`inputs`, `outputs`, `mylib` (has `scanPaths`).

## Commands

```bash
darwin-rebuild switch --flake .#K-MBP        # or .#K-MBA
sudo nixos-rebuild switch --flake .#Think    # or .#Link, .#Super

# check without activating: swap `switch` for `build` (darwin) / `test` (nixos)
nix flake show          # list configurations
nix flake update <input>
```

## Adding a module

1. Create it under `modules/{base,nixos,darwin}/...` — `scanPaths` picks it up.
2. Declare `options.kdlt.<...>.enable = lib.mkEnableOption "..."` and guard
   the body with `lib.mkIf`.
3. Enable it in the machine config(s) that want it.

For a Darwin app/setting that only some Macs want, add it to an existing
bundle or a new `bundles/<name>.nix`, not the always-on layer.

## Gotchas

- **`stateVersion` is frozen at "24.05".** Never change it.
- **Timezone** is hardcoded `Asia/Manila` in `modules/base/system.nix`.
- **`homebrew.onActivation.cleanup = "zap"`**: any cask/brew/masApp not
  declared anywhere gets uninstalled on switch. Adding a machine's apps
  means declaring all of them.
- **Darwin activation over SSH can stall** on a GUI auth prompt (new
  `.app` registration, `brew zap` removing an app). Do first-time or
  app-changing switches with a screen attached or via Screen Sharing.
- **K-MBA ssh**: uses `~/.ssh/id_rsa-mac`, not the `id_ed25519` the config
  lists first — a harmless "no such identity" warning until a key is made.
- **nixvim** is an external flake (`github:KDLT/nixvim`). Change it there,
  then `nix flake update nixvim` here and rebuild.
- **impermanence** (Think): persistent paths are under
  `kdlt.storage.{dataPrefix,cachePrefix}`; undeclared files vanish on boot.

## Package placement

Prefer Nix over Homebrew for anything cross-platform (pinning, rollback,
works on every machine). Truly universal CLI tools go in
`modules/base/system.nix`. macOS-only GUI apps and integration utilities
(`mas`, `m-cli`, `terminal-notifier`) stay Homebrew.
