{
  config,
  lib,
  pkgs,
  hyprlandFlake,
  ...
}:
let
  hyprland = config.kdlt.graphical.hyprland;
  username = config.kdlt.username;
in
{
  imports = [
    ./packages.nix
    ./nvidia.nix
    ./settings.nix
  ];

  options = {
    kdlt = {
      graphical.hyprland.enable = lib.mkEnableOption "Enable hyprlandwm"; # now defined in ../../default.nix, SIKE
    };
  };

  # hyprland configs to set when enable = true in host's configuration.nix
  config = lib.mkIf hyprland.enable {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    # TODO-COMPLETE: test if this xserver setting is required by hyprland, NO
    services = {
      # xserver.enable = false; # TODO commenting this out because amd wiki entry sets this to true

      # minimal login manager daemon
      greetd = {
        enable = true;
        settings.default_session = {
          user = username;
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
        };
      };
    };
    # # hyprland, hyprlock, & waybar
    programs = {
      xwayland.enable = true;
      hyprland = {
        enable = true;
        package = hyprlandFlake.hyprland;
        portalPackage = hyprlandFlake.xdg-desktop-portal-hyprland;
      };
      hyprland.xwayland.enable = true;
      waybar.enable = true;
      hyprlock.enable = true;
    };

    # hyprland xdg portal
    xdg.portal = {
      enable = true;
      extraPortals = [ hyprlandFlake.xdg-desktop-portal-hyprland ];
      configPackages = [ hyprlandFlake.xdg-desktop-portal-hyprland ];
    };

    # is this the login screen?
    # services.displayManager = {
    #   sddm = {
    #     enable = true;
    #     package = pkgs.kdePackages.sddm;
    #     wayland.enable = true;
    #   };
    # };
  };
}
