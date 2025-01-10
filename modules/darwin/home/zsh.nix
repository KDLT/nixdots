{ ... }:
{
  imports = [ ../../nixos/core/shells/zsh.nix ];
  config = {
    # this one creates zsh configs under /etc
    # required to make nix-darwin function correctly
    programs.zsh.enable = true;
  };
}
