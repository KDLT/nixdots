{
  imports = [
    ./zfs-single.nix
    ./hardware.nix
  ];

  networking = {
    hostName = "Think"; # Define your hostname.
    hostId = "b6ccd37e"; # head -c 8 /etc/machine-id
    # nameservers = ["" ""];
  };

  kdlt = {
    username = "kba";
    fullname = "Kenneth Balboa Aguirre";
    email = "aguirrekenneth@gmail.com";
    stateVersion = "24.05";

    development.virtualization.docker.enable = true; # testing out docker

    core = {
      wireless.enable = true;
      nix.enableDirenv = false; # unfreePackages = [];
      nixvim.enable = true;
      laptop = true; # pending configs for laptop mode
      server = true; # server mode configs
    };
    graphical = {
      enable = true; # try disabling
      wallpaper = ../../assets/wallpaper-green.png;
      sound = true;
      stylix.enable = true;
      hyprland = {
        enable = true;
        # use `hyprctl monitors` for info display info
        # LG 4K120hz screen connected via HDMI 2.1 cable to thinkpad
        # display = "HDMI-A-2, 3840x2160@30, 0x0, 1";
        display = "eDP-1, 1920x1080@60, 0x0, 1"; # native thinkpad display
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
