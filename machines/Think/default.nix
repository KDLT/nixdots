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
      wallpaper = ../../assets/wallpaper-green.png;
      sound = true;
      laptop = true; # pending configs for laptop mode
      amd.enable = true;
      stylix.enable = true;
      hyprland = {
        enable = true;
        # use `hyprctl monitors` for info
        display = "DP-2, 3840x2160@120, 0x0, 1"; # DP-2 attached to USB 4.0 port via adapter, steady connection
        # display = "DP-1, 3840x2160@100, 0x0, 1"; # kumukurap 'yung 120hz sa DP-1, doesn't carry enough bandwidth
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

  # pending transfer to its own module
  services.keyd = {
    enable = true;
    keyboards.t480 = {
      ids = [ "0001:0001" ];
      settings = {
        main = {
          leftshift = "overload(shift, esc)";
          capslock = "overload(control, esc)";
          backslash = "backspace";
          backspace = "backslash";
          leftcontrol = "layer(leftcontrol)";
        };
        control = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          slash = "delete";
        };
      };
    };

    keyboards.hhkb = {
      ids = [ "04fe:0021" ];
      settings = {
        main = {
          #leftshift = "overload(shift, esc)";
          leftcontrol = "overload(control, esc)";
        };
        control = {
          h = "left";
          j = "down";
          k = "up";
          l = "right";
          slash = "delete";
        };
      };
    };
  };
}
