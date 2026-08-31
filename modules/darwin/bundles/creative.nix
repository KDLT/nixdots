{ lib, config, ... }:
let
  cfg = config.kdlt.darwin.bundles.creative;
in
{
  options.kdlt.darwin.bundles.creative.enable = lib.mkEnableOption ''
    creative / media apps: affinity, blender, framer, iina, backdrop, and
    the Apple media apps (DaVinci Resolve, CapCut, Keynote, Numbers, Pages)'';

  config = lib.mkIf cfg.enable {
    homebrew = {
      casks = [
        "affinity" # affinity studio
        "blender@lts" # 3D creation suite
        "framer" # UI/UX prototyping
        "iina" # video player
        "backdrop" # animated wallpaper tester
      ];
      masApps = {
        "DaVinci Resolve" = 571213070;
        "Capcut" = 1500855883;
        "Keynote" = 409183694;
        "Numbers" = 409203825;
        "Pages" = 409201541;
      };
    };
  };
}
