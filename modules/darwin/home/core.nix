# Lifted from https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/home/core.nix
{ username, ... }:
{
  home-manager.users.${username} = {
    programs = {
      lazygit.enable = true;

      # direnv and nix-direnv
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      # modern ls
      eza = {
        enable = true;
        git = true;
        icons = "auto";
      };

      # skim provides executable sk
      # where you'd want to use grep, use sk instead
      skim = {
        enable = true;
        enableBashIntegration = true;
      };

      zoxide.enable = true;
    };
  };
}
