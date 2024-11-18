{
  config,
  lib,
  pkgs,
  ...
}:
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
            package = mkOption {
              type = package;
              default = [ (pkgs.nerdfonts.override { fonts = [ "CommitMono" ]; }) ];
            };
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
            package = mkOption {
              type = package;
              default = [ (pkgs.nerdfonts.override { fonts = [ "Go-Mono" ]; }) ];
            };
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
            package = mkOption {
              type = package;
              default = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
            };
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
            package = mkOption {
              type = package;
              default = [ "noto-fonts-emoji" ];
            };
          };
        };
      };
    };
  };

  config = {
    fonts = mkIf (!config.kdlt.nerdfont.enable) {
      packages = with pkgs; [
        jetbrains-mono
        fira-code
        iosevka
        noto-fonts-color-emoji
      ];
      fontconfig = {
        defaultFonts = {
          # testing all jetbrains
          monospace = [ "Jetbrains Mono" ];
          serif = [ "Jetbrains Mono" ];
          sansSerif = [ "Jetbrains Mono" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
