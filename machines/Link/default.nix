{
  imports = [
    ./zfs-mirror.nix
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

    core = {
      wireless.enable = true;
      nixvim.enable = true;
      laptop = false;
      server = false;
    };

    development = {
      virtualization.docker.enable = true;
      nodejs.enable = true;
    };

    graphical = {
      enable = true;
      wallpaper = ../../assets/wallpaper-green.png;
      sound = true;
      amd.enable = true;
      stylix.enable = true;
      hyprland = {
        enable = true;
        # use `hyprctl monitors` for info
        display = "DP-2, 3840x2160@120, 0x0, 1"; # DP-2 attached to USB 4.0 port via adapter, steady connection
      };
      xdg.enable = true;
    };
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
        # declarations for more files directories can be added here, for
        # syntax, see ../../modules/storage/impermanence/default.nix
      };
      dataPrefix = "/data";
      cachePrefix = "/cache";
      share.nfs.enable = true;
      share.samba.enable = true;
    };
    nerdfont = {
      # font name reference:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/shas.nix
      enable = true;
      monospace.name = "CommitMono";
      serif.name = "Go-Mono";
      sansSerif.name = "JetBrainsMono";
      emoji.name = "Noto-Emoji";
    };
  };
}
