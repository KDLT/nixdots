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
  graphical = config.kdlt.graphical;
  hyprland = config.kdlt.graphical.hyprland;
  username = config.kdlt.username;
in
{

  imports = mylib.scanPaths ./.;

  options = {
    kdlt = {
      graphical.hyprland.enable = lib.mkEnableOption "Enable hyprlandwm"; # now defined in ../../default.nix, SIKE
    };
  };

  # hyprland configs to set when enable = true in host's configuration.nix
  config = lib.mkIf (hyprland.enable && graphical.enable) {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    ## wiki says nixosModule enable critical components to run Hyprland properly
    ## https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/
    programs = {
      hyprland = {
        enable = true; # <- this is the nixos module for hyprland
        package = pkgs.hyprland; # default
        portalPackage = pkgs.xdg-desktop-portal-hyprland; # default

        xwayland.enable = true; # defaults true anyway, sanity check
      };
      # these are instead enabled via their respective configs
      # waybar.enable = true;
      # hyprlock.enable = true;
    };

    # systemd startup for hyprland
    programs.uwsm = {
      enable = true;
      waylandCompositors.hyprland = {
        binPath = "/run/current-system/sw/bin/Hyprland";
        comment = "Hyprland session managed by uwsm";
        prettyName = "Hyprland";
      };
    };

    services = {
      ## AMD GPU instructs xserver be enabled as per https://nixos.wiki/wiki/AMD_GPU
      xserver.enable = lib.mkIf config.kdlt.graphical.amd.enable true;

      # minimal login manager daemon that does nothing for now
      greetd = {
        enable = true;
        settings.default_session = {
          user = username;
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
        };
      };
    };

    # On Lag, FPS drops uncomment this
    # hardware.opengl = {
    #   package = pkgs-unstable.mesa.drivers;
    #   # 32-bit support, e.g, for steam
    #   driSupport32Bit = true;
    #   package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
    # };

  };
}
