{ lib, config, ... }:
let
  cfg = config.kdlt.darwin.bundles.creative;
in
{
  options.kdlt.darwin.bundles.creative.enable = lib.mkEnableOption ''
    creative / media apps: affinity, blender, framer, iina, backdrop, and
    the Apple media apps (DaVinci Resolve, CapCut, GarageBand, iMovie,
    Keynote, Numbers, Pages)'';

  config = lib.mkIf cfg.enable {
  };
}
