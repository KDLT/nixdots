{
  description = "Initial Flake with Disko, Impermanence Install";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";

    # nixvim.url = "github:pete3n/nixvim-flake"; # https://github.com/pete3n/nixvim-flake 27* panget
    # nixvim.url = "github:dc-tec/nixvim"; # https://github.com/dc-tec/nixvim 30* cleanest so far pero walang q so dealbreaker
    # nixvim.url = "github:niksingh710/nvix"; # https://github.com/niksingh710/nvix 69* clickable folds, topbar depth map, wrong formatter, awful color
    nixvim.url = "github:redyf/Neve"; # https://github.com/redyf/Neve 153* i want the clickable folds from niksingh710, reduce on-screen mess, proper indentation highlighting from dc-tec to here
    # nixvim.url = "github:elythh/nixvim"; # https://github.com/elythh/nixvim 155* panget
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      impermanence,
      home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        Link = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            disko.nixosModules.disko
            ./zfs-mirror.nix
            impermanence.nixosModules.impermanence
            ./configuration.nix
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };
}
