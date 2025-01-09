{ lib, pkgs, ... }:
{
  imports = [ ../../nixos/core/utils/tmux ];
  config = {
    programs.tmux = lib.optionalAttrs pkgs.stdenv.hostPlatform.isMacOS {
      enable = true;
      enableMouse = true;
      enableVim = true;
      enableFzf = true;
      enableSensible = true;
      extraConfig = ''
        # set-option -g default-command "exec /run/current-system/sw/bin/zsh -l"
        # this forces the spawning of login shells, this is crucial as fuck for MacOS
        set-option -g default-command "exec $(which zsh) -l"
      '';
    };
  };
}
