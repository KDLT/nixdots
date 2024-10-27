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
      zfs.enable = true;
      persistence = true;
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
      # monospace.fontName = "IBMPlexMono";
      serif.fontName = "Go-Mono";
      sansSerif.fontName = "JetBrainsMono";
      emoji.fontName = "Noto-Emoji";
    };
  };
}
