{
  lib,
  config,
  pkgs,
  ...
}: {
  options = let
    # these are used on kitty, not here
    # nerdFontName = name: builtins.replaceStrings ["-"] [""] name + " Nerd Font";
    # nerdFontPkg = nerdFontName: (pkgs.nerdfonts.override { fonts = [ nerdFontName ]; });
  in {
    kdlt.nerdfont = {
      enable = lib.mkEnableOption "Use Nerdfonts";
      monospace = {
        fontName = lib.mkOption {
          type = lib.types.str;
          # default = nerdFontName "CommitMono";
          default = "CommitMono";
        };
        fontPackage = lib.mkOption {
          type = lib.types.package;
          default = pkgs.nerdfonts.override {fonts = [config.kdlt.nerdfont.monospace.fontName];};
        };
      };

      serif = {
        fontName = lib.mkOption {
          type = lib.types.str;
          default = "Go-Mono";
        };
        fontPackage = lib.mkOption {
          type = lib.types.package;
          default = pkgs.nerdfonts.override {fonts = [config.kdlt.nerdfont.serif.fontName];};
        };
      };

      sansSerif = {
        fontName = lib.mkOption {
          type = lib.types.str;
          default = "JetBrainsMono";
        };
        fontPackage = lib.mkOption {
          type = lib.types.package;
          default = pkgs.nerdfonts.override {fonts = [config.kdlt.nerdfont.sansSerif.fontName];};
        };
      };

      emoji = {
        fontName = lib.mkOption {
          type = lib.types.str;
          default = "Noto-Emoji";
        };
        fontPackage = lib.mkOption {
          type = lib.types.package;
          default = pkgs.noto-fonts-monochrome-emoji;
        };
      };
    };
  };

  config = lib.mkIf config.kdlt.nerdfont.enable {
    fonts = {
      packages = [
        config.kdlt.nerdfont.monospace.fontPackage
        config.kdlt.nerdfont.serif.fontPackage
        config.kdlt.nerdfont.sansSerif.fontPackage
        config.kdlt.nerdfont.emoji.fontPackage
      ];

      fontconfig = {
        enable = true;

        defaultFonts = {
          monospace = [config.kdlt.nerdfont.monospace.fontName];
          serif = [config.kdlt.nerdfont.serif.fontName];
          sansSerif = [config.kdlt.nerdfont.sansSerif.fontName];
          emoji = [config.kdlt.nerdfont.emoji.fontName];
        };

        # subpixel = {
        #   rgba = "rbg"; # oled c3 is actually rwbg, option for it doesn't exist
        # };
      };
    };
  };
}
