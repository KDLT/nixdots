# ~/dotfiles/modules/core/users/default.nix
{
  config,
  lib,
  pkgs,
  user,
  ...
}:
{
  options = {
    kdlt = {
      username = lib.mkOption {
        default = "${user.username}";
        type = lib.types.str;
        example = "kba";
      };
      fullname = lib.mkOption {
        default = "${user.fullname}";
        type = lib.types.str;
        example = "Kenneth Balboa Aguirre";
      };
      email = lib.mkOption {
        default = "${user.email}";
        type = lib.types.str;
        example = "aguirrekenneth@gmail.com";
      };
    };
  };

  config = {
    users = {
      # true is default, TODO: set to false after
      # implementing secrets management, see hashedPasswordFile commented lines below
      mutableUsers = true;
      users = {
        ${config.kdlt.username} = {
          # this is a different declaration from the rest of the config
          isNormalUser = true;
          description = "${config.kdlt.fullname}";
          extraGroups = [
            "wheel"
            "networkmanager"
          ];
          shell = pkgs.zsh;
          hashedPassword = "$y$j9T$0cy6huv8H2SHD0mAajoIF0$KIb3CaPIV8MiXjyIUSqWznuzVKbuJj8GI77u.2zfGU3";
          # hashedPasswordFile = config.sops.secrets."users/${username}".path;
        };
        # root.hashedPasswordFile = config.sops.secrets."users/root".path;
        root.hashedPassword = "$y$j9T$G/2CdvV6kjU6zXGWO6lgR/$dEYkMHuN9xD4za2WufZQx3NeiRcIvrlAKAAif6DoVr5";
      };
    };
  };
}
