{ mylib, ... }:
{
  imports = mylib.scanPaths ./.;
  # imports = [
  #   ./cmp
  #   ./editor
  #   ./git
  #   ./lsp
  #   ./snippets
  #   ./themes
  #   ./ui
  #   ./utils
  # ];
}
