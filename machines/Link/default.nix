{
  imports = [
    ./zfs-mirror.nix
    ./zfs-mirror-copy.nix
    ./hardware.nix
  ];

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
      zfs = {
        enable = true;
        zpool = {
          name = "rpool";
          dataset = {
            # note that these datasets are always relative to the declared poolname
            # do not include your selected poolname and no leading forward slash
            cache = "local/cache";
            data = "persist/data";
          };
        };
      };
      impermanence = {
        enable = true;
        # list of directories and files to persist in addition to defaults
        # located in ../../modules/storage/impermanence/default.nix
        persist = {
          systemDirs = [ ];
          systemFiles = [ ];
          homeDirs = [ ];
          homeFiles = [ ];
          cacheDirs = [ ];
        };
      };
      dataPrefix = "/data";
      cachePrefix = "/cache";
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
