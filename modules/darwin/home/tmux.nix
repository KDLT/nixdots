{ lib, pkgs, ... }:
{
  imports = [ ../../nixos/core/utils/tmux.nix ];
  config = {
    programs.tmux = lib.optionalAttrs pkgs.stdenv.hostPlatform.isMacOS {
      enable = true;
      enableMouse = true;
      enableVim = true;
      enableFzf = true;
      enableSensible = true;
      extraConfig = ''
        # set-option -g default-command "exec /run/current-system/sw/bin/zsh -l"
        # this forces the spawning of login shells
        # without this MacOS opens the default -sh for root user
        set-option -g default-command "exec $(which zsh) -l"
      '';
    };
  };
}
