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
            # Pinned to a commit, not `main` -- tracking the branch makes this
            # hash go stale on every upstream push. Bump both together:
            #   git ls-remote https://github.com/yazi-rs/flavors main
            #   nix-prefetch-url --unpack https://github.com/yazi-rs/flavors/archive/<rev>.tar.gz
            rev = "20b47bfd78880c2674899597fd26bc01b21ff48c";
            hash = "sha256-NGnfrQdsnQITKCZ0oh6DCxeCR2ozJoPAZetsi3ghHAI=";
          }
          + "/${flavor}.yazi";
      };

      plugins = {
        autosession = pkgs.fetchFromGitHub {
          owner = "barbanevosa";
          repo = "autosession.yazi";
          # pinned to a commit, not `main` (see the flavors note above)
          rev = "7a12b201898a83395dc9981d63a204ac1e103416";
          hash = "sha256-ahTVzM996HMY049mXtJd66oOXI0zz5IpM/a5od1V364=";
        };
      };
    };
  };
}
