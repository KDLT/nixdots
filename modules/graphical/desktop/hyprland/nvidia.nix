{
  config,
  lib,
  ...
}:
with lib; let
  hyprlandConfig = config.kdlt.graphical.hyprland;
  nvidiaConfig = config.kdlt.core.nvidia;
  username = config.kdlt.username;
in {
  config = mkIf (hyprlandConfig.enable && nvidiaConfig.enable) {
    # nvidia hyprland reference: https://wiki.hyprland.org/Nvidia/#installation
    # for wayland compositors to load properly these nvidia driver modules need to be loaded in initramfs
    boot = {
      # normally in /etc/modprobe.d/nvidia.conf located in /etc/modprobe.d/nixos.conf
      extraModprobeConfig = "options nvidia_drm modeset=1 fbdev=1\n";
      # normally in /etc/mkinitcpio.conf located in /etc/modules-load.d/nixos.conf
      initrd.kernelModules = [
        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];
    };

    # hyprland requirements for nvidia gpus
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-utils"
        "lib32-nvidia-utils"
      ];

    home-manager.users.${username} = {...}: {
      wayland.windowManager.hyprland = {
        settings = {
          cursor = {
            no_hardware_cursors = true; # nvidia hyprland requirement
          };
          # nvidia hyprland environment variables
          env = [
            "LIBVA_DRIVER_NAME,nvidia"
            "XDG_SESSION_TYPE,wayland"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "NIXOS_OZONE_WL,1"
          ];
        };
      };
    };
  };
}
