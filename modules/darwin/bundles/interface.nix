{ lib, config, ... }:
let
  cfg = config.kdlt.darwin.bundles.interface;
in
{
  options.kdlt.darwin.bundles.interface.enable = lib.mkEnableOption ''
    macOS desktop interface layer: aerospace tiling WM (+ its config),
    kitty, karabiner-elements, raycast, stats, jankyborders, and the
    window/space `system.defaults` those depend on'';

  config = lib.mkIf cfg.enable {
  };
}
