# ~/dotfiles/modules/graphical/stylix/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  stylix = config.kdlt.graphical.stylix;
in
# wallpaper = config.kdlt.graphical.wallpaper;
# userName = config.kdlt.username;
with lib;
{
  options.kdlt.graphical = {
    stylix.enable = mkEnableOption "Use Stylix";
  };

  config = mkIf stylix.enable {
    # enabling this solved the stylix infinite recursion issue on rebuild
    # as long as i am using nixosModule and NOT the homeConfigurations one
    programs.dconf = {
      enable = true; # not sure if this is the place to declare it
    };

    stylix = {
      enable = true;
      autoEnable = true;
      targets.nixvim.enable = false; # don't style nixvim
      polarity = "dark";
      image = ../../../assets/wallpaper-blue.png;
      # somewhere in /nix/store/ is the base16 scheme directory, the yaml filenames are the options
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/twilight.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/saga.yaml";
      # base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
      base16Scheme = "${pkgs.base16-schemes}/share/themes/primer-dark.yaml";
      # see generated color scheme in /etc/stylix/generated.json

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
      };

      fonts = {
        monospace = {
          name = config.kdlt.nerdfont.monospace.name;
          package = pkgs.nerdfonts;
        };
        sansSerif = {
          name = config.kdlt.nerdfont.sansSerif.name;
          package = pkgs.nerdfonts;
        };
        serif = {
          name = config.kdlt.nerdfont.serif.name;
          package = pkgs.nerdfonts;
        };
        emoji = {
          name = config.kdlt.nerdfont.emoji.name;
          package = pkgs.noto-fonts-color-emoji;
        };
        sizes = {
          terminal = 16;
          applications = 14; # 16 is too extra
          popups = 18;
          desktop = 16;
        };
      };
    };

    # this conflicts with home-manager's nixosModule
    # home-manager.users.${userName} = {
    #   stylix = {
    #     enable = true;
    #     autoEnable = true;
    #
    #     opacity = {
    #       applications = 1.0;
    #       desktop = 1.0;
    #       popups = 1.0;
    #       terminal = 1.0;
    #       polarity = "dark";
    #     };
    #   };
    # };
  };
}
