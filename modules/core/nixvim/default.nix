# Reference: https://github.com/GaetanLepage/nix-config/tree/master/home/modules/tui/neovim
{
  config,
  lib,
  ...
}: let
in {
  # imports exist outside the options and config attribute set
  imports = [
    ./options.nix
    ./keymaps.nix
    ./colorscheme.nix
    ./completions.nix
    ./plugins
  ];

  options = {
    kdlt.core.nixvim.enable = lib.mkEnableOption "nixvim";
  };

  config = lib.mkIf config.kdlt.core.nixvim.enable {
    home-manager.users.${config.kdlt.username} = {...}: {
      home.shellAliases = {
        v = "nvim";
      };
    };

    programs.nixvim = {
      enable = true;
      enableMan = true; # enable nixvim manual
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      luaLoader.enable = true;

      # cmd [[hi Normal guibg=NONE ctermbg=NONE]]
      performance = {
        combinePlugins = {
          enable = true;
          standalonePlugins = [
            "hmts.nvim"
            "nvim-treesitter"
            "lualine.nvim"
          ];
        };
        byteCompileLua.enable = true;
      };
    };
  };
  # };
}
