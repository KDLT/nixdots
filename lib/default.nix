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
}
