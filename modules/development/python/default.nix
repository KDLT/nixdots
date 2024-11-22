{
  pkgs,
  lib,
  config,
  user,
  ...
}:
{
  # i choose to not declare these options here but in ../default.nix instead
  options = {
    kdlt.development = {
      python.enable = lib.mkEnableOption "Python312";
    };
  };

  config = lib.mkIf config.kdlt.development.python.enable {
    home-manager.users.${config.kdlt.username} = {
      home.packages = with pkgs; [
        python312
        python312Packages.pip
        python312Packages.pipx
        # pkgs.python312Full # i wonder what full means
      ];
    };
  };
}
