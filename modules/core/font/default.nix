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
          };
        };
      };
    };
  };

  ## when enabled download the entire nerdfont package
  config = {
    fonts = mkIf (!config.kdlt.nerdfont.enable) {
      packages = with pkgs; [
        jetbrains-mono
        fira-code
        iosevka
      ];
      fontconfig = {
        defaultFonts = {
          # testing all jetbrains
          monospace = [ "JetbrainsMono" ];
          serif = [ "JetbrainsMono" ];
          sansSerif = [ "JetbrainsMono" ];
        };
      };
    };
  };
}
