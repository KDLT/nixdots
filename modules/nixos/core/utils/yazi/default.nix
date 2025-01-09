# ~/dotfiles/modules/core/utils/yazi/default.nix
{
  config,
  pkgs,
  ...
}:
let
  userName = config.kdlt.username;
in
{
  config = {
    environment.systemPackages = [
      pkgs.yazi
    ];
    home-manager.users.${config.kdlt.username} = {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        # initLua = ./init.lua;
        shellWrapperName = "y";

        settings = {
          log = {
            enabled = true;
          };
          manager = {
            show_hidden = true;
            sort_by = "modified";
            sort_dir_first = true;
            sort_reverse = true;
          };
        };

        keymap = {
          manager.prepend_keymap = [
            {
              on = [
                "g"
                "r"
              ];
              run = "cd /run/media/${userName}";
              desc = "Cd to mounted removeable drive";
            }
            {
              on = [
                "m"
                "i"
              ];
              run = "linemode size_and_mtime";
              desc = "Set linemode to size_and_mtime (custom function)";
            }
          ];
        };

      };
    };
  };
}
