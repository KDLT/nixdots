{
  config,
  lib,
  ...
}:
let
  dataPrefix = config.kdlt.storage.dataPrefix;
in
{
  config = {
    # some zfs, persistence juju here
    # config.kdlt.core.zfs = lib.mkMerge [
    #   (lib.mkIf config.kdlt.persistence.enable {
    #     ensureSystemExists = [ "${config.kdlt.dataPrefix}/etc/ssh" ];
    #   })
    #   (lib.mkIf (!config.kdlt.core.persistence.enable) {})
    # ];

    # persistence for ssh keys
    services.openssh = {
      enable = true;
      settings = {
        # better disable this when ssh clients have been enrolled
        PasswordAuthentication = true;
        PermitRootLogin = "prohibit-password";
      };
      hostKeys = [
        {
          path = "${dataPrefix}" + "/ssh/ssh_host_K-Link_ed25519_key";
          type = "ed25519";
        }
        {
          path = "${dataPrefix}" + "/ssh/ssh_host_K-Link_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };

    # services.openssh = {
    #   enable = true;
    #
    #   settings = {
    #     # PasswordAuthentication = false;
    #     PasswordAuthentication = true; # how the fuck would you enroll keys?
    #     PermitRootLogin = "prohibit-password";
    #
    #     # remove stale sockets
    #     StreamLocalBindUnlink = "yes";
    #   };
    #
    #   hostKeys = [
    #     # {
    #     #   bits = 4096;
    #     #   path = "/etc/ssh/ssh_host_rsa_key";
    #     #   type = "rsa";
    #     # }
    #     {
    #       bits = 4096;
    #       path = "/etc/ssh/ssh_host_ed25519_key";
    #       type = "ed25519";
    #     }
    #   ];
    # };
  };
}
