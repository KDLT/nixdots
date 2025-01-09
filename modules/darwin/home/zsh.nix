{ ... }:
{
  imports = [ ../../nixos/core/shells/zsh ];
  config = {
    # kdlt.core.zfs = lib.mkMerge [
    #   (lib.mkIf config.kdlt.core.persistence.enable {
    #     systemCacheLinks = ["/root/.local/share/autojump"];
    #     homeCacheLinks = [".local/share/autojump"];
    #   })
    # ];

    # this one creates zsh configs under /etc
    # required to make nix-darwin function correctly
    programs.zsh.enable = true;
  };
}
