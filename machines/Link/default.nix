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

  # sanity check that the display is not the problem re: low refresh rate
  # Enable the GNOME Desktop Environment.
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

  kdlt = {
    username = "kba";
    fullname = "Kenneth Balboa Aguirre";
    email = "aguirrekenneth@gmail.com";
    stateVersion = "24.05";

    core = {
      wireless.enable = true;
      nix.enableDirenv = false;
      nixvim.enable = true;
      laptop = false;
      server = false;
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
    };
    nerdfont = {
      # font name reference:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/shas.nix
      enable = true;
      monospace.name = "CommitMono";
      serif.name = "Go-Mono";
      sansSerif.name = "JetbrainsMono";
      emoji.name = "Noto-Emoji";
    };
  };
}
