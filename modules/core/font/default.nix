{
  config,
  lib,
  pkgs,
  ...
}:
let
  stylix = config.kdlt.graphical.stylix;
in
with lib;
{
  options = {
    kdlt.nerdfont = with types; {
      enable = mkEnableOption "Use Nerdfonts";

      # font name reference:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/shas.nix
      monospace = mkOption {
        type = submodule {
          options = {
            name = mkOption {
              type = str;
              default = "CommitMono";
            };
            # package = mkOption {
            #   type = package;
            #   default = pkgs.nerdfonts.override {
            #     fonts = [ name ];
            #   };
            # };
          };
        };
      };
      serif = mkOption {
        type = submodule {
          options = {
            name = mkOption {
              type = str;
              default = "Go-Mono";
            };
            # package = mkOption {
            #   type = package;
            #   default = pkgs.nerdfonts.override {
            #     fonts = [ "GoMono" ];
            #   };
            # };
          };
        };
      };
      sansSerif = mkOption {
        type = submodule {
          options = {
            name = mkOption {
              type = str;
              default = "JetBrainsMono";
            };
            # package = mkOption {
            #   type = package;
            #   default = pkgs.nerdfonts.override {
            #     fonts = [ name ];
            #   };
            # };
          };
        };
      };
      emoji = mkOption {
        type = submodule {
          options = {
            name = mkOption {
              type = str;
              default = "Noto-Emoji";
            };
            # package = mkOption {
            #   type = package;
            #   default = pkgs.noto-fonts-monochrome-emoji;
            # };
          };
        };
      };
    };
  };

  ## when enabled download the entire nerdfont package
  config = mkIf (!config.kdlt.nerdfont.enable) {
    fonts.packages = [ pkgs.jetbrains-mono ];
  };
}
