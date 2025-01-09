{
  config,
  lib,
  pkgs,
  ...
}:
let
  amd = config.kdlt.graphical.amd;
in
with lib;
{
  config = mkIf amd.enable {
    # have the kernel load the correct driver immediately
    boot.initrd.kernelModules = [ "amdgpu" ];

    boot.kernelParams = [
      "video=HDMI-A-1:3840x2560@120"
      # "video=HDMI-A-1:3840x2560@119.98"
    ];

    # make xserver use the the "amdgpu" driver
    services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };

    hardware.graphics = {
      enable = true;
    };

    # HIP libraries hard-code workaround
    systemd.tmpfiles.rules = mkBefore [
      # trying mkBefore so this gets listed before bluetooth in
      "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
    ];
  };
}
