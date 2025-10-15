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
      # initLua = ./init.lua;
      shellWrapperName = "y";

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
            sha256 = "030h9pa47ivphx6mvrcsppqlchpjzmscn5gxxavcw7yldb4f3xpp";
          }
          + "/${flavor}.yazi";
      };
    };
  };
}
