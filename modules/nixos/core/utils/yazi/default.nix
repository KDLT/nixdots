{
  pkgs,
  username,
  ...
}:
let
  flavor = "catppuccin-mocha";
in
{
  home-manager.users.${username} = {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "y";

      # autosession.yazi: persists open tabs/cwds/sorting on quit,
      # restores them on next launch
      initLua = ''
        require("autosession"):setup()
      '';

      settings = {
        log = {
          enabled = true;
        };
        mgr = {
          show_hidden = true;
          sort_by = "mtime"; # mtime is the new properer syntax instead of modified
          sort_dir_first = true;
          sort_reverse = true;
          linemode = "size"; # show filesizes by default
        };

        opener = {
          csv = [
            {
              run = ''csvlens "$@"'';
              block = true; # takes over the terminal, like the editor opener
              desc = "csvlens";
            }
          ];
        };

        open = {
          # prepend so csv files use csvlens instead of falling through
          # to the default text/* -> editor rule
          prepend_rules = [
            {
              url = "*.csv";
              use = "csv";
            }
          ];
        };
      };

      keymap = {
        mgr.prepend_keymap = [
          {
            on = [
              "g"
              "r"
            ];
            run = "cd /run/media/${username}";
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
          {
            on = [ "q" ];
            run = "plugin autosession -- save-and-quit";
            desc = "Save session and quit";
          }
          {
            on = [ "E" ];
            run = ''shell 'nvim "%h"' --block'';
            desc = "Force open hovered file with nvim";
          }
        ];
      };

      # theme = builtins.fromTOML (builtins.readFile ./theme.toml);
      theme = {
        flavor.dark = flavor;
        flavor.light = flavor;
      };

      flavors = {
        ${flavor} =
          pkgs.fetchFromGitHub {
            owner = "yazi-rs";
            repo = "flavors";
            rev = "main";
            # sha256 = "sha256-placeholder"; # replace with actual hash using
            # `nix-prefetch-url --unpack https://github.com/yazi-rs/flavors/archive/main.tar.gz`
            sha256 = "1ahfr4k5cxf07n59385ln3f03wp4icxywxgzv1pa3ijkgv84idks";
          }
          + "/${flavor}.yazi";
      };

      plugins = {
        autosession = pkgs.fetchFromGitHub {
          owner = "barbanevosa";
          repo = "autosession.yazi";
          rev = "main";
          # `nix-prefetch-url --unpack https://github.com/barbanevosa/autosession.yazi/archive/main.tar.gz`
          sha256 = "1bnzapfs3fgn6clr5krkimf0xapbbp95wrlgscc77s3xrz6da53a";
        };
      };
    };
  };
}
