{
  username,
  inputs,
  # pkgs,
  ...
}:
{
  # personal nixvim flake from my github, see inputs
  home-manager.users.${username} = {
    home.packages = [
      # note the hostsystem is specified to be aarch64-darwin
      inputs.nixvim.packages.aarch64-darwin.default # my nixvim config
    ];

    # temporarily revert back to vanilla neovim for nix-darwin
    # home.packages = [ pkgs.neovim ];
  };
}
