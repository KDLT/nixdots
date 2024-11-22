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

  config = with pkgs; {
    fonts = {
      packages =
        if (config.kdlt.nerdfont.enable) then
          [
            # as per nixos wiki, specification of nerdfonts override must also occur in fonts.packages as well
            # https://nixos.wiki/wiki/Fonts
            (nerdfonts.override {
              fonts = [
                "Go-Mono"
                "CommitMono"
                "JetBrainsMono"
              ];
            })
            noto-fonts
            noto-fonts-extra
            noto-fonts-emoji
            noto-fonts-color-emoji
          ]
        # these are the defaults when nerdfonts is not installed
        else
          [
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
