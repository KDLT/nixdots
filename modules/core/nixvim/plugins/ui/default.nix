{ mylib, ... }:
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./bufferline.nix
  #   ./colorizer.nix
  #   ./lualine.nix
  #   ./startify.nix
  # ];
}
