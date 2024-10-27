{
  pkgs,
  config,
  ...
}:
{
  imports = [ ./hardware.nix ];

  networking = {
    hostName = "Link"; # Define your hostname.
    hostId = "765c4d0e"; # head -c 8 /etc/machine-id
    # nameservers = ["" ""];
  };

  kdlt = {
    username = "kba";
    fullname = "Kenneth Balboa Aguirre";
    email = "aguirrekenneth@gmail.com";
    stateVersion = "24.05";
    storage = {
      zfs = rec {
        enable = true;
        impermanence = true;
        # list of directories and files to persist in addition to defaults
        # located in ../../modules/storage/impermanence/default.nix
        # persist = {
        #   systemDirs = [ "" ];
        #   systemFiles = [ "" ];
        #   homeDirs = [ "" ];
        #   homeFiles = [ "" ];
        #   cacheDirs = [ "" ];
        # };
        # uncomment if poolName's own attribute set doesn't work
        # poolName = "rpool";
        # # datasets options in ./zfs-mirror.nix
        # datasets = {
        #   data = "persist/data";
        #   cache = "local/cache";
        # };
        poolName = "rpool";
        ${poolName} = {
          data = "persist/data";
          cache = "local/cache";
        };
      };
    };
    core = {
      wireless = {
        enable = true;
      };
      nvidia = {
        enable = false;
        super = false;
      };
      nix = {
        enableDirenv = false;
        # unfreePackages = [];
      };
      nixvim = {
        enable = true;
      };
    };
    graphical = {
      enable = true;
      sound = true;
      laptop = false;
      # stylix = {
      #   enable = true;
      # };
      hyprland = {
        enable = true;
        # use `hyprctl monitors` for info
        display = "HDMI-A-1, 3840x2160@119.88, 0x0, 1";
      };
      xdg.enable = true;
    };
    nerdfont = {
      enable = true;
      monospace.fontName = "CommitMono";
      serif.fontName = "Go-Mono";
      sansSerif.fontName = "JetBrainsMono";
      emoji.fontName = "Noto-Emoji";
    };
  };
}
