{
  config,
  lib,
  ...
}:
let
  userName = config.kdlt.username;
in
{
  options = {
    kdlt.core.nix = {
      enableDirenv = lib.mkOption { default = true; };
      unfreePackages = lib.mkOption { default = [ ]; };
    };
  };

  config = {
    # kdlt.core.zfs = lib.mkMerge [
    #   (lib.mkIf config.kdlt.persistence.enable {
    #     homeCacheLinks = [ "local/share/direnv" ];
    #     systemCacheLinks = [ "/root/.local/share/direnv" ];
    #     systemDataLinks = [ "/var/lib/nixos" ];
    #   })
    #   (lib.mkIf (!config.kdlt.core.persistence.enable) {})
    # ];

    programs.nh = {
      enable = true;
      clean.enable = false;
      flake = "/home/${userName}/nixdots";
    };

    nixpkgs.config = {
      allowUnfree = true;
    };

    nix = {
      settings = {
        trusted-users = [
          userName
          "@wheel"
        ];
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;

        # manual optimise: nix-store --optimise
        auto-optimise-store = true;
      };

      # remove nix-channel related tools & configs in favor of flakes
      channel.enable = false;

      # garbage collect
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };

      nixPath = [
        "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
        "nixos-config=/home/${userName}/nixdots"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    };
  };
}
