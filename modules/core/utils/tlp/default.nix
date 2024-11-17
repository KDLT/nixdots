{
  pkgs,
  config,
  lib,
  ...
}:
let
  laptop = config.kdlt.core.laptop;
  server = config.kdlt.core.server;
in
with lib;
with pkgs;
{
  environment.systemPackages = mkIf laptop [
    tlp
    linuxKernel.packages.linux_6_6.tp_smapi # specifically for thinkpad, should be conditional
  ];

  services.tlp = lib.mkIf (laptop && server) {
    enable = true;
    settings = {
      # bat0 is the internal battery, i opt to remove bat1 on server mode
      START_CHARGE_THRESH_BAT0 = 40;
      STOP_CHARGE_THRESH_BAT0 = 60;

      # thinkpad t480 has a removable battery presumably bat1
      # START_CHARGE_THRESH_BAT1 = 75;
      # STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };
}
