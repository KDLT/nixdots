{
  config,
  ...
}:
let
  dataPrefix = config.kdlt.storage.dataPrefix;
in
{
  config = {
    services.openssh = {
      enable = true;
      settings = {
        # better disable this when ssh clients have been enrolled
        PasswordAuthentication = true;
        PermitRootLogin = "prohibit-password";
      };
      hostKeys = [
        # hostkeys reside in dataPrefix for persistence
        {
          path = "${dataPrefix}" + "/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "${dataPrefix}" + "/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };
  };
}
