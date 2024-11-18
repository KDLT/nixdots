{
  imports = [ ./hardware.nix ];

  # NOTE: Configs here are so outdated, refer to the either Link or Think defaults
  networking = {
    hostName = "K-Super";
    # hostId = "";
    # nameservers = [ "" "" ];
  };

  kdlt = {
    username = "kba";
    fullname = "Kenneth Balboa Aguirre";
    email = "aguirrekenneth@gmail.com";
    stateVersion = "24.05";
    storage = {
      btrfs = {
        enable = true;
      };
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
      sound = true;
      laptop = false;
      nvidia = {
        enable = true;
        super = true;
      };
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
