{ mylib, ... }:
{
  # Opt-in feature bundles for Darwin hosts. Each file declares
  # `kdlt.darwin.bundles.<name>.enable` (default false) and gates its own
  # packages / settings behind it. A machine turns on the bundles it wants in
  # machines/<host>/default.nix. Nothing here applies unless enabled.
  #
  # See CONTEXT.md ("bundle", "always-on layer") and
  # docs/adr/0001-darwin-config-uses-opt-in-bundles.md.
  imports = mylib.scanPaths ./.;
}
