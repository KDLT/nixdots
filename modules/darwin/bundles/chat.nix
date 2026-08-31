{ lib, config, ... }:
let
  cfg = config.kdlt.darwin.bundles.chat;
in
{
  options.kdlt.darwin.bundles.chat.enable = lib.mkEnableOption ''
    desktop chat clients: telegram, discord'';

  config = lib.mkIf cfg.enable {
  };
}
