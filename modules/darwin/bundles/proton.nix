{ lib, config, ... }:
let
  cfg = config.kdlt.darwin.bundles.proton;
in
{
  options.kdlt.darwin.bundles.proton.enable = lib.mkEnableOption ''
    Proton suite: proton-mail, proton-drive, protonvpn, and the
    Proton Pass Safari extension'';

  config = lib.mkIf cfg.enable {
    homebrew = {
      casks = [
        "proton-mail"
        "proton-drive"
        "protonvpn"
      ];
      masApps = {
        "Proton Pass for Safari" = 6502835663;
      };
    };
  };
}
