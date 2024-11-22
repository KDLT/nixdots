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
      START_CHARGE_THRESH_BAT0 = 41;
      STOP_CHARGE_THRESH_BAT0 = 69;

      # thinkpad t480 has a removable battery presumably bat1
      # START_CHARGE_THRESH_BAT1 = 75;
      # STOP_CHARGE_THRESH_BAT1 = 80;

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;
    };
  };
}
