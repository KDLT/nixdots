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

    # make xserver use the the "amdgpu" driver
    services.xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
    };

    # HIP libraries hard-code workaround
    systemd.tmpfiles.rules = mkBefore [
      # trying mkBefore so this gets listed before bluetooth in
      "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
    ];

    # Blender package for hardware encoding
    # clinfo is used to verify that openCL is correctly set up
    environment.systemPackages = with pkgs; [
      blender-hip
      clinfo
    ];

    hardware.opengl.extraPackages = with pkgs; [
      rocmPackages.clr.icd # OpenCL
      amdvlk # Vulkan 64 bit
    ];

    # Vulkan 32 bit
    # hardware.opengl.extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ]; # old syntax, getting deprecated
    hardware.graphics.extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];

    # 64-bit Vulkan is enabled by default. 32-bit Vulkan has to be enabled.
    # hardware.opengl.driSupport32Bit = true; # getting deprecated
    hardware.graphics.enable32Bit = true; # new declaration syntax

    # multi-monitors config from the wiki but not certain if this is an amd thing or general
    # `head /sys/class/drm/*/status` to find the right display name
    # `wlr-randr` for roots based compositors like hyprland to get available resolutions
    # boot.kernelParams = [
    #   "video=DP-1:2560x1440@144"
    #   "video=HDMI-A-1:3840x2560@120"
    # ];
  };
}
