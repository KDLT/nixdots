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
        # more options located in ../../modules/storage/impermanence/default.nix
      };
      dataPrefix = "/data";
      cachePrefix = "/cache";
    };
    core = {
      wireless = {
        enable = true;
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
      # wallpaper = "home/kba/Pictures/aesthetic-wallpapers/images/chill.gif";
      wallpaper = ../../assets/wallpaper.png;
      sound = true;
      laptop = false;
      amd.enable = true;
      stylix.enable = true;
      hyprland = {
        enable = true;
        # enable = false; # part of the refresh rate sanity check
        # use `hyprctl monitors` for info
        # display = "HDMI-A-1, 3840x2160@119.88, 0x0, 1";
        # display = "DP-2, 3840x2160@120, 0x0, 1"; # DP-2 attached to USB 4.0 port via adapter, steady connection
        display = "DP-1, 3840x2160@100, 0x0, 1"; # kumukurap 'yung 120hz sa DP-1
      };
      xdg.enable = true;
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
    # nerdfont = {
    #   enable = true;
    #   monospace.fontName = "CommitMono";
    #   serif.fontName = "Go-Mono";
    #   sansSerif.fontName = "JetBrainsMono";
    #   emoji.fontName = "Noto-Emoji";
    # };
  };
}
