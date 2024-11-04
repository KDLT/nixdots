{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    sops-nix.url = "github:Mic92/sops-nix"; # secrets management
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence"; # nuke / on every boot

    disko.url = "github:nix-community/disko/latest";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim"; # for unstable channel
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    # another attempt to use the stated url from the wiki, no follows
    # WARNING: this might break rebuild, reporting back, it rebuilt and rebooted
    hyprland.url = "github:hyprwm/Hyprland";

    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.inputs.nixpkgs.follows = "nixpkgs";

    hyprlock.url = "github:hyprwm/hyprlock";
    hyprlock.inputs.nixpkgs.follows = "hyprland";

    anyrun.url = "github:anyrun-org/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:danth/stylix";
    # stylix.inputs.nixpkgs.follows = "nixpkgs-stable"; # testing this commented out

    nur.url = "github:nix-community/NUR"; # nix user repository
  };

  outputs =
    {
      self,
      nixpkgs,
      impermanence,
      disko,
      sops-nix,
      hyprland,
      anyrun,
      home-manager,
      nix-index-database,
      nixvim, # not using my own nixvim config just yet

      stylix,
      ...
    }@inputs:
    let
      # https://nixos.wiki/wiki/Nix_Language_Quirks
      # Since this is inside outputs the self argument allows
      # ALL `outputs` inheritable
      inherit (self) outputs; # this makes outputs inheritable below

      # stolen from ryan4yin/nix-config, for the scanPaths
      inherit (inputs.nixpkgs) lib;
      mylib = import ./lib { inherit lib; };
      ## stolen

      # yet to decipher
      # allSystemNames = [ "x86_64-linux" "aarch64-darwin" ];
      # forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      user = {
        username = "kba";
        fullname = "Kenneth B. Aguirre";
        email = "aguirrekenneth@gmail.com";
      };

      hyprlandFlake = hyprland.packages.${pkgs.stdenv.hostPlatform.system};
      anyrunFlake = anyrun.packages.${pkgs.system};

      inheritArgs = {
        inherit
          inputs
          outputs
          user
          hyprlandFlake
          anyrunFlake
          mylib # pass (notreally) mylib here
          ;
      };
      sharedModules = [
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager
        nix-index-database.nixosModules.nix-index
        nixvim.nixosModules.nixvim
        sops-nix.nixosModules.sops
        disko.nixosModules.disko
        impermanence.nixosModules.impermanence

        ./modules # this points to default.nix that imports storage, core, development, graphical
      ];
    in
    {
      nixosConfigurations = {
        # 5700X3D 4080 Super Desktop
        Super = nixpkgs.lib.nixosSystem {
          modules = sharedModules ++ [ ./machines/Super/default.nix ];
          specialArgs = inheritArgs; # this contains mylib
        };

        # Beelink Mini PC
        Link = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = inheritArgs;
          modules = sharedModules ++ [
            ./machines/Link/default.nix
          ];
        };
      };
    };
}
