{ mylib, ... }:
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./autopairs.nix
  #   ./completions.nix
  # ];
}
