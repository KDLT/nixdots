{ lib, ... }:
with lib;
{
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        attrsets.filterAttrs (
          path: _type:
          # include directories  OR  (  ignore default.nix   AND  include .nix files)
          (_type == "directory") || ((path != "default.nix") && (strings.hasSuffix ".nix" path))
        ) (builtins.readDir path)
      )
    );

  # scanPaths =
  #   path:
  #   builtins.map (f: (path + "/${f}")) (
  #     builtins.attrNames (
  #       lib.attrsets.filterAttrs (
  #         path: _type:
  #         (_type == "directory") # include directories
  #         || (
  #           (path != "default.nix") # ignore default.nix
  #           && (lib.strings.hasSuffix ".nix" path) # include .nix files
  #         )
  #       ) (builtins.readDir path)
  #     )
  #   );

}
