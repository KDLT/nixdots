{
  lib,
  config,
  inputs,
  anyrunFlake,
  ...
}: let
  username = config.kdlt.username;
in {
  options = {
    kdlt.graphical = {
      anyrun.enable = lib.mkEnableOption "Enable Anyrun";
    };
  };

  config = lib.mkIf config.kdlt.graphical.anyrun.enable {
    nix.settings = {
      builders-use-substitutes = true;
      extra-substituters = ["https://anyrun.cachix.org"];
      extra-trusted-public-keys = ["anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="];
    };

    home-manager.users.${username} = {...}: {
      imports = [
        inputs.anyrun.homeManagerModules.default
      ];
      programs.anyrun = {
        enable = true;
        config = {
          plugins = with anyrunFlake; [
            applications
            randr
            rink
            shell
            symbols
            translate
          ];

          width.fraction = 0.3;
          y.absolute = 15;
          hidePluginInfo = true;
          closeOnClick = true;
        };

        extraCss = '''';
      };
    };
  };
}
