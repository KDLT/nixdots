{ lib, config, ... }:
let
  cfg = config.kdlt.darwin.bundles.printing3d;
in
{
  options.kdlt.darwin.bundles.printing3d.enable = lib.mkEnableOption ''
    3D-printing slicers and CAD: orcaslicer, superslicer, autodesk-fusion'';

  config = lib.mkIf cfg.enable {
    homebrew.casks = [
      "orcaslicer"
      "superslicer"
      "autodesk-fusion"
    ];
  };
}
