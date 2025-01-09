{
  mylib,
  pkgs,
  ...
}:
{
  imports = mylib.scanPaths ./.;
  # i cannot use scanpaths on oh-my-posh because it has other file types?!
  # imports = [
  #   ./zsh
  #   ./oh-my-posh
  #   ./starship
  # ];

  environment.shells = with pkgs; [
    zsh
    bash
    fish
  ];

  users = {
    defaultUserShell = pkgs.zsh;
  };
}
