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

    # Blender package for hardware encoding
    # clinfo is used to verify that openCL is correctly set up
    # environment.systemPackages = with pkgs; [
    #   blender-hip
    #   clinfo
    # ];

    # hardware.opengl.extraPackages = with pkgs; [
    #   rocmPackages.clr.icd # OpenCL
    #   amdvlk # Vulkan 64 bit
    # ];

    # hardware.graphics = {
    #   extraPackages = with pkgs; [
    #     rocmPackages.clr.icd # OpenCL
    #     amdvlk # Vulkan 64 bit
    #     mesa.opencl # for old cards
    #   ];
    # };

    ## prob optionals below
    # 32-bit vulkan
    # hardware.graphics = {
    #   enable32Bit = true;
    #   extraPackages32 = [ pkgs.driversi686Linux.amdvlk ];
    # };

    # multi-monitors config from the wiki but not certain if this is an amd thing or general
    # `head /sys/class/drm/*/status` to find the right display name
    # `wlr-randr` for roots based compositors like hyprland to get available resolutions
    # boot.kernelParams = [
    #   "video=DP-1:2560x1440@144"
    #   "video=HDMI-A-1:3840x2560@120"
    # ];

    # boot.kernelParams = [
    #   # for Southern Island 1 cards radeon 7000
    #   # "radeon.si_support=0"
    #   # "amdgpu.si_support=1"
    #
    #   # for Sea Island cards - radeon 8000
    #   # "radeon.cik_support=0"
    #   # "amdgpu.cik_support=1"
    # ];
  };
}
