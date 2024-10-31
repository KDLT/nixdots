# Reference: https://github.com/GaetanLepage/nix-config/tree/master/home/modules/tui/neovim
{
  config,
  lib, # still have to import this
  mylib, # it doesn't come with lib
  ...
}:
{
  # testing out scanPaths
  imports = mylib.scanPaths ./.;
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
    home-manager.users.${config.kdlt.username} = {
      home = {
        # use dc-tec's nixvim flake while i haven't properly set up mine yet
        # nixvim url declared in flake.nix
        # packages = [
        #   inputs.nixvim.packages.${pkgs.system}.default
        # ];
        sessionVariables = {
          EDITOR = "nvim";
        };
        shellAliases = {
          v = "nvim";
        };
      };
    };

    # commenting out my own nixvim declarations in favor of dc-tec's flake
    programs.nixvim = {
      enable = true;
      enableMan = true; # enable nixvim manual
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;

      # cmd [[hi Normal guibg=NONE ctermbg=NONE]]
      # performance = {
      #   combinePlugins = {
      #     enable = true;
      #     standalonePlugins = [
      #       "hmts.nvim"
      #       "nvim-treesitter"
      #       "lualine.nvim"
      #     ];
      #   };
      #   byteCompileLua.enable = true;
      # };
    };
  };
  # };
}
