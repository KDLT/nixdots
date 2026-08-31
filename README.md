# nixdots

Flake-based NixOS and nix-darwin configuration for my machines. Options live
under the `kdlt.*` namespace; modules are auto-imported by `scanPaths`
(`lib/default.nix`).

## Machines

| Flake attr | Kind | Notes |
|---|---|---|
| `K-MBP` | nix-darwin | Apple Silicon MacBook Pro, main machine |
| `K-MBA` | nix-darwin | MacBook Air, mostly headless, Nix via the Determinate installer |
| `Think` | NixOS | ThinkPad T480, ZFS + impermanence, Hyprland, Plex |
| `Link` | NixOS | Beelink mini PC, ZFS mirror, AMD, Hyprland |
| `Super` | NixOS | 5700X3D / RTX 4080 Super desktop (config stale; follow Think/Link) |

## Apply

```bash
darwin-rebuild switch --flake .#K-MBP          # macOS  (or .#K-MBA)
sudo nixos-rebuild switch --flake .#Think      # NixOS  (or .#Link, .#Super)
```

Use `build` instead of `switch` to compile without activating,
`--rollback` to revert to the previous generation.

## Layout

```
machines/<host>/    per-host: identity, hardware, which kdlt.* options and bundles to enable
modules/base/       shared between NixOS and Darwin
modules/nixos/      Linux: core, storage, graphical, development
modules/darwin/     macOS: the always-on layer plus bundles/
```

`nix flake show` lists every configuration. Option definitions are in the
module files (`grep -rl mkOption modules/`). For orientation: `CLAUDE.md`
(layout, conventions, gotchas), `CONTEXT.md` (glossary), `docs/adr/`
(why decisions were made).

## Darwin bundles

macOS apps and settings that differ between machines are opt-in **bundles**
gated by `kdlt.darwin.bundles.<name>.enable`. Each machine config turns on
the bundles it wants; everything both Macs always get is the always-on layer
(`modules/darwin` outside `bundles/`). Background in `CONTEXT.md` and
`docs/adr/0001-darwin-config-uses-opt-in-bundles.md`.

## Secrets

`sops-nix`, recipients in `.sops.yaml`. Encrypt before committing.

## nixvim

Editor config is an external flake, `github:KDLT/nixvim`. Update it with
`nix flake update nixvim` then rebuild.
