{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    kdlt = {
      core = {
        nvidia.enable = lib.mkEnableOption "nvidia gpu";
        nvidia.super = lib.mkEnableOption "nvidia super series gpu";
      };
    };
  };
  config = lib.mkIf config.kdlt.core.nvidia.enable {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "nvidia-x11"
        "nvidia-settings"
        "nvidia-persistenced"
      ];

    # nixpkgs.config.allowUnfree = true;

    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    # Enable OpenGL
    hardware.opengl = {
      enable = true;
    };

    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false; # suspend/resume system corruption issue here
      powerManagement.finegrained = false;
      open = false;
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      # package = lib.mkIf (!config.kdlt.nvidia.super) config.boot.kernelPackages.nvidiaPackages.stable;
      package =
        if !config.kdlt.core.nvidia.super # use the package below if nvidia gpu is not super
        then config.boot.kernelPackages.nvidiaPackages.stable
        else
          # reference: https://nixos.wiki/wiki/Nvidia#Running_the_new_RTX_SUPER_on_nixos_stable
          # Special config to load the latest 550 driver for the support of SUPER series card
          let
            rcu_patch = pkgs.fetchpatch {
              url = "https://github.com/gentoo/gentoo/raw/c64caf53/x11-drivers/nvidia-drivers/files/nvidia-drivers-470.223.02-gpl-pfn_valid.patch";
              hash = "sha256-eZiQQp2S/asE7MfGvfe6dA/kdCvek9SYa/FFGp24dVg=";
            };
          in
            config.boot.kernelPackages.nvidiaPackages.mkDriver {
              version = "550.40.07";
              sha256_64bit = "sha256-KYk2xye37v7ZW7h+uNJM/u8fNf7KyGTZjiaU03dJpK0=";
              sha256_aarch64 = "sha256-AV7KgRXYaQGBFl7zuRcfnTGr8rS5n13nGUIe3mJTXb4=";
              openSha256 = "sha256-mRUTEWVsbjq+psVe+kAT6MjyZuLkG2yRDxCMvDJRL1I=";
              settingsSha256 = "sha256-c30AQa4g4a1EHmaEu1yc05oqY01y+IusbBuq+P6rMCs=";
              persistencedSha256 = "sha256-11tLSY8uUIl4X/roNnxf5yS2PQvHvoNjnd2CB67e870=";

              patches = [rcu_patch];
            };
    };

    # TODO-COMPLETE: transfer nvidia settings that hyprland requires to hyprland/default.nix
    environment = {
      variables = {
        # the following environment variables are lifted from dc-tec's config
        __GL_GSYNC_ALLOWED = "1"; # allow gsync
        __GL_VRR_ALLOWED = "1"; # variable refresh rate, set to 0 when having problems on some games
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
      };
      shellAliases = {
        nvidia-settings = "nvidia-settings --config='$XDG_CONFIG_HOME'/nvidia/settings";
      };
    };
  };
}
