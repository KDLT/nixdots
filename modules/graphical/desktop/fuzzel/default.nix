# ~/dotfiles/modules/graphical/desktop/fuzzel.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    kdlt.graphical.fuzzel.enable = lib.mkEnableOption "fuzzel";
  };
  config = lib.mkIf config.kdlt.graphical.fuzzel.enable {
    home-manager.users = {
      ${config.kdlt.username} = {
        home.packages = with pkgs; [papirus-icon-theme];
        programs.fuzzel = {
          enable = true;
          settings = {
            main = {
              terminal = "${pkgs.kitty}/bin/kitty";
              layer = "overlay";
              icon-theme = "Papirus-Dark";
              prompt = " ";
              font = "CommitMono Nerd Font:size=36";
            };

            # commented colors out because of stylix conflicting definitions
            colors = {
              background = "24273add";
              text = "cad3f5ff";
              selection = "5b6078ff";
              selection-text = "cad3f5ff";
              border = "b7bdf8ff";
              match = "ed8796ff";
              selection-match = "ed8796ff";
            };

            border = {
              radius = "10";
              width = "1";
            };

            dmenu = {
              exit-immediately-if-empty = "yes";
            };
          };
        };
      };
    };
  };
}
