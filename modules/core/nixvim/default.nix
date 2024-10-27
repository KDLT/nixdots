# Reference: https://github.com/GaetanLepage/nix-config/tree/master/home/modules/tui/neovim
{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  # commenting out my own nixvim declarations in favor of dc-tec's flake
  # imports = [
  #   ./options.nix
  #   ./keymaps.nix
  #   ./colorscheme.nix
  #   ./completions.nix
  #   ./plugins
  # ];

  options = {
    kdlt.core.nixvim.enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf config.kdlt.core.nixvim.enable {
    # use dc-tec's nixvim flake while i haven't properly set up mine yet
    # nixvim url declared in flake.nix
    home-manager.users.${config.kdlt.username} = {
      home = {
        packages = [
          inputs.nixvim.packages.${pkgs.system}.default
        ];
        sessionVariables = {
          EDITOR = "nvim";
        };
        shellAliases = {
          v = "nvim";
        };
      };
    };

    # commenting out my own nixvim declarations in favor of dc-tec's flake
    # programs.nixvim = {
    #   enable = true;
    #   enableMan = true; # enable nixvim manual
    #   defaultEditor = true;
    #   viAlias = true;
    #   vimAlias = true;
    #   luaLoader.enable = true;
    #
    #   # cmd [[hi Normal guibg=NONE ctermbg=NONE]]
    #   performance = {
    #     combinePlugins = {
    #       enable = true;
    #       standalonePlugins = [
    #         "hmts.nvim"
    #         "nvim-treesitter"
    #         "lualine.nvim"
    #       ];
    #     };
    #     byteCompileLua.enable = true;
    #   };
    # };
  };
  # };
}
