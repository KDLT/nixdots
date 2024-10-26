{pkgs, ...}: {
  imports = [
    ./zsh
    ./oh-my-posh
    ./starship
  ];

  environment.shells = with pkgs; [
    zsh
    bash
    fish
  ];

  users = {
    defaultUserShell = pkgs.zsh;
  };
}
