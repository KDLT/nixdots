# Darwin config uses opt-in bundles

## Context

`modules/darwin` (homebrew, system, development) was written for one machine,
K-MBP, and applied unconditionally to every Darwin host. When K-MBA was
added as a second, mostly-headless Mac that wants a smaller set of apps, its
machine config had to `lib.mkForce` the entire homebrew list to strip it
back down. That does not scale and hides what each machine actually runs.

## Decision

Split the Darwin config into an always-on layer plus opt-in **bundles**
(`modules/darwin/bundles/<name>.nix`), each gated by
`kdlt.darwin.bundles.<name>.enable` (default false). The always-on layer
holds only what every Mac wants; anything that varies between machines is a
bundle a machine turns on. Machine configs enable bundles, never `mkForce`
shared lists.

Bundles chosen: interface, proton, creative, printing3d, chat, dev. They
stay bundles even when every current machine enables one (interface, proton,
dev), so a future headless machine can leave them off.

## Considered options

- **Everything opt-in** (base defines no content, every machine lists its
  full package set): rejected. Both Macs want the CLI toolbelt and sane
  defaults; re-declaring that per machine is ceremony with no payoff.
- **Lean base, K-MBP as the outlier** (base carries the K-MBA-appropriate
  minimum, K-MBP adds the rest): rejected. "Base" then quietly means
  "minimal machine", which misleads the next reader and does not survive a
  third machine with different minimums.

## Consequences

- The docker engine is no longer shared: `dev` provides only colima, and
  each machine declares its own docker (K-MBP: `docker-desktop` cask;
  K-MBA: `docker` formula).
- `services.tailscale` moved to a new always-on `modules/darwin/networking`
  since both hosts run it.
- Four K-MBP-only apps (google-drive, google-gemini, shottr, superwhisper)
  have no natural bundle yet and sit in `machines/K-MBP/default.nix` under a
  "not yet sorted" comment.
- NixOS modules keep their existing shape; this pattern is Darwin-only for
  now.
