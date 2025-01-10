# Lifted from https://github.com/ryan4yin/nix-darwin-kickstarter/blob/main/rich-demo/home/core.nix
{ config, lib, inputs, username, ...}: {
  imports = [
    # not a good fit for tmux if zsh via home-manager is imported
    # ../../core/shells/zsh/default.nix
  ];

  config = {
    home-manager.users.${username} = {
      home.packages = [
        inputs.nixvim.packages.aarch64-darwin.default # my nixvim config
      ];

      programs = {
        # separate kitty declaration for macos only
       kitty = {
          enable = true;
          settings = {
            font_size = 20;
            window_padding_width = 12;
            background_opacity = "0.89";
            background_blur = 20;
            hide_window_decorations = "titlebar-only"; # hides title bar but not window border
            # tab settings
            tab_bar_style = "powerline";
            tab_powerline_style = "round";
          };
        };

        lazygit.enable = true;

        # direnv and nix-direnv
        programs.direnv = {
          enable = true;
          enableZshIntegration = true;
          nix-direnv.enable = true;
        };

        # modern ls
        eza = {
          enable = true;
          git = true;
          icons = "auto";
          enableZshIntegration = true;
        };

        # yazi terminal file manager configs for macos
        yazi = {
          enable = true;
          shellWrapperName = "y";
          enableZshIntegration = true;
          settings = {
            log.enabled = true;
            manager = {
              show_hidden = true;
              sort_by = "modified";
              sort_dir_first = true;
              sort_reverse = true;
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
