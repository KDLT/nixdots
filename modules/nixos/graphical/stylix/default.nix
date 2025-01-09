# ~/dotfiles/modules/graphical/stylix/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  stylix = config.kdlt.graphical.stylix;
  laptop = config.kdlt.core.laptop;
  nerdfont = config.kdlt.nerdfont;
  monospace = nerdfont.monospace;
  serif = nerdfont.serif;
  sansSerif = nerdfont.sansSerif;
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
      image = ../../../../assets/wallpaper-blue.png;
      # somewhere in /nix/store/ is the base16 scheme directory, the yaml filenames are the options
      # use nix-locate
      base16Scheme = "${pkgs.base16-schemes}/share/themes/primer-dark.yaml";
      # see generated color scheme in /etc/stylix/generated.json

      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = if laptop then 16 else 24;
      };

      fonts =
        if nerdfont.enable then
          {
            monospace.name = monospace.name;
            monospace.package = pkgs.nerdfonts.override { fonts = [ monospace.name ]; };

            sansSerif.name = sansSerif.name;
            sansSerif.package = pkgs.nerdfonts.override { fonts = [ sansSerif.name ]; };

            serif.name = serif.name;
            serif.package = pkgs.nerdfonts.override { fonts = [ serif.name ]; };

            emoji.name = config.kdlt.nerdfont.emoji.name;
            emoji.package = pkgs.noto-fonts-color-emoji;

            sizes = {
              terminal = if laptop then 12 else 16;
              applications = if laptop then 11 else 14;
              popups = if laptop then 13 else 18;
              desktop = if laptop then 12 else 16;
            };
          }
        else
          {
            monospace.name = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;
            sansSerif.name = builtins.elemAt config.fonts.fontconfig.defaultFonts.sansSerif 0;
            serif.name = builtins.elemAt config.fonts.fontconfig.defaultFonts.serif 0;
            emoji.name = builtins.elemAt config.fonts.fontconfig.defaultFonts.emoji 0;
            packages = config.fonts.packages;

            sizes = {
              terminal = if laptop then 12 else 16;
              applications = if laptop then 11 else 14;
              popups = if laptop then 13 else 18;
              desktop = if laptop then 12 else 16;
            };
          };

    };
  };
}
