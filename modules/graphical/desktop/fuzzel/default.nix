# ~/dotfiles/modules/graphical/desktop/fuzzel.nix
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    kdlt.graphical.fuzzel.enable = lib.mkEnableOption "fuzzel";
  };
  config = lib.mkIf config.kdlt.graphical.fuzzel.enable {
    home-manager.users = {
      ${config.kdlt.username} = {
        home.packages = with pkgs; [ papirus-icon-theme ];
        programs.fuzzel = {
          enable = true;
          settings = {
            main = {
              width = "55";
              terminal = "${pkgs.kitty}/bin/kitty -e";
              layer = "overlay";
              prompt = "λ  ";
              font = lib.mkForce "CommitMono Nerd Font:size=30";
              icon-theme = "Papirus-Dark";
              horizontal-pad = "65";
              vertical-pad = "25";
              inner-pad = "6";
            };

            # same as from hyprland config
            border = {
              radius = "15";
              width = "2";
            };

            dmenu = {
              exit-immediately-if-empty = "yes";
            };

            # commented colors out because of stylix conflicting definitions
            # colors = {
            #   background = "24273add";
            #   text = "cad3f5ff";
            #   selection = "5b6078ff";
            #   selection-text = "cad3f5ff";
            #   border = "b7bdf8ff";
            #   match = "ed8796ff";
            #   selection-match = "ed8796ff";
            # };
          };
        };
      };
    };
  };
}
