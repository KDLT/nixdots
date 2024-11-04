{
  config,
  lib,
  mylib,
  pkgs,
  hyprlandFlake,
  inputs,
  ...
}:
let
  # uncomment pkgs below to replace succeeding pkgs calls with this version
  # pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  hyprland = config.kdlt.graphical.hyprland;
  username = config.kdlt.username;
in
{

  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./nvidia.nix
  #   ./packages.nix
  #   ./settings.nix
  # ];

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

    ## wiki says nixosModule enable critical components to run Hyprland properly
    ## https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
    programs = {
      # xwayland.enable = true;
      hyprland = {
        enable = true; # <- this is the nixos module for hyprland
        package = pkgs.hyprland; # default
        portalPackage = pkgs.xdg-desktop-portal-hyprland; # default

        ## currently testing hyprland's claim about the correct defaults
        # package = hyprlandFlake.hyprland;
        # portalPackage = hyprlandFlake.xdg-desktop-portal-hyprland;

        xwayland.enable = true; # defaults true anyway, sanity check
      };
      # these are instead enabled via their respective configs
      # waybar.enable = true;
      # hyprlock.enable = true;
    };

    # hyprland xdg portal, commenting these out
    ## As per https://wiki.hyprland.org/Hypr-Ecosystem/xdg-desktop-portal-hyprland/
    ## On the nixos tab, "XDPH is already enabled by the NixOS module for Hyprland"
    # xdg.portal = {
    #   enable = true;
    #   extraPortals = [ hyprlandFlake.xdg-desktop-portal-hyprland ];
    #   configPackages = [ hyprlandFlake.xdg-desktop-portal-hyprland ];
    # };

    # On Lag, FPS drops uncomment this
    # hardware.opengl = {
    #   package = pkgs-unstable.mesa.drivers;
    #   # 32-bit support, e.g, for steam
    #   driSupport32Bit = true;
    #   package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
    # };

    # TODO-COMPLETE: test if this xserver setting is required by hyprland, NO
    services = {
      ## AMD GPU instructs xserver be enabled as per https://nixos.wiki/wiki/AMD_GPU
      xserver.enable = lib.mkIf config.kdlt.graphical.amd.enable true;

      # minimal login manager daemon
      greetd = {
        enable = true;
        settings.default_session = {
          user = username;
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
        };
      };
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
