# ~/dotfiles/modules/core/utils/gpg/default.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  config = {
    # kdlt.core.zfs = lib.mkMerge [
    #   (lib.mkIf config.kdlt.core.persistence.enable {
    #     homeDataLinks = [
    #       {
    #         directory = ".gnupg";
    #         mode = "0700";
    #       }
    #     ];
    #   })
    #   (lib.mkIf (!config.kdlt.core.persistence.enable) {})
    # ];

    environment.systemPackages = with pkgs; [
      gnupg
      pinentry-gtk2
    ];

    home-manager.users.${config.kdlt.username} = {
      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        enableSshSupport = true;
        pinentryPackage = pkgs.pinentry-gtk2;
        defaultCacheTtl = 46000;
        extraConfig = ''
          allow-preset-passphrase
        '';
      };
    };
  };
}
