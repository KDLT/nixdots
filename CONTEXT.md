# nixdots

Flake-based NixOS and nix-darwin configuration for several machines. This
file is the glossary for terms whose meaning is specific to this repo. For
build commands and module layout, see CLAUDE.md and README.md.

## Language

**Machine config**:
The file `machines/<host>/default.nix`. Sets the host's identity (hostname,
platform, hardware) and turns on the bundles and `kdlt.*` options that host
wants. Holds host-specific settings, not shared logic.
_Avoid_: host file, node config

**Bundle** (Darwin only):
An opt-in group of applications and settings that only some machines want,
gated behind `kdlt.darwin.bundles.<name>.enable`. Lives in
`modules/darwin/bundles/<name>.nix`. Nothing in a bundle applies unless a
machine config enables it. Current bundles: interface, proton, creative,
printing3d, chat, dev.
_Avoid_: profile, role, feature flag, preset

**Always-on layer** (Darwin):
The Darwin configuration every host gets with no toggle: the CLI toolbelt,
fonts, Touch ID, core `system.defaults`, `services.tailscale`, and the
handful of apps both Macs always want. Everything that differs between
machines is a bundle instead. Physically, it is `modules/darwin` minus
`modules/darwin/bundles`.
_Avoid_: base, core, default profile

**Interface parity**:
The choice to give K-MBA the same desktop interface as K-MBP (aerospace,
kitty, karabiner, jankyborders) even though K-MBA runs mostly headless, so
it is familiar when used directly. Expressed as K-MBA enabling the
`interface` bundle.
