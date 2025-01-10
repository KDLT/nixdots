{ username, inputs, ... }:
{
  # personal nixvim flake from github for aarch64-darwin
  home-manager.users.${username} = {
    home.packages = [
      inputs.nixvim.packages.aarch64-darwin.default # my nixvim config
    ];
  };
}
