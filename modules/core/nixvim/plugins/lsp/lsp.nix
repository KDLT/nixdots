{
  programs.nixvim.plugins = {
    lsp-format.enable = true;

    lsp = {
      enable = true;
      keymaps = {
        silent = true;
        diagnostic = {
          # navigate diagnostics
          # "<leader>[" = "goto_prev";
          # "<leader>]" = "goto_next";
        };
        lspBuf = {
          gd = "definition";
          gD = "references";
          gt = "type_definition";
          gi = "implementation";
          K = "hover";
          "<F2>" = "rename";
        };
      };

      servers = {
        nixd.enable = true; # Nix
        clangd.enable = true; # C
        texlab.enable = true; # LaTeX
        lua_ls.enable = true; # Lua
        pylsp.enable = true; # Python
        jsonls.enable = true; # JSON
        cssls.enable = true; # CSS
        tailwindcss.enable = true; # Tailwind CSS
        html.enable = true; # HTML
        emmet_ls.enable = true; # Emmet
        sqls.enable = true; # SQL
        ts_ls.enable = true; # TypeScript
        yamlls.enable = true; # YAML
      };
    };
  };
}
