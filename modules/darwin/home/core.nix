# Lifted from https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/home/core.nix
{ config, lib, inputs, username, ...}: {
  imports = [
    ../../core/shells/zsh/default.nix
  ];

  config = {
    home-manager.users.${username} = {
      home.packages = [
        inputs.nixvim.packages.aarch64-darwin.default # my nixvim config
      ];

      programs = {
       kitty = {
          enable = true;
          settings = {
            font_size = 20;
            window_padding_width = 12;
            background_opacity = "0.89";
            background_blur = 20;
            hide_window_decorations = "titlebar-only"; # hides title bar and window border
          };
        };

        # for zsh config for darwin also uses modules/core/shells/zsh

        lazygit.enable = true;

        # modern ls
        eza = {
          enable = true;
          git = true;
          icons = "auto";
          enableZshIntegration = true;
        };

        # terminal file manager
        yazi = {
          enable = true;
          shellWrapperName = "y";
          enableZshIntegration = true;
          settings = {
            manager = {
              show_hidden = true;
              sort_dir_first = true;
            };
          };
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
  };
}
