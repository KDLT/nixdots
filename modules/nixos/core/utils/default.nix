{ mylib, username, config, ... }:
{
  imports = mylib.scanPaths ./.;
  config = {
    home-manager.users.${username} = {
      programs = {
        bat.enable = true;
        bottom.enable = true;
        btop = {
          enable = true;
          settings.vim_keys = true;
        };
        direnv = {
          enable = config.kdlt.core.nix.direnv.enable;
          nix-direnv.enable = true;
        };
        eza = {
          enable = true;
          icons = "auto";
          git = true;
        };
        fzf.enable = true;
        ripgrep.enable = true;
        zoxide.enable = true;
      };
    };
  };
}
