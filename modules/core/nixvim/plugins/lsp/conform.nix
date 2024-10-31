{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    # example setting from https://nix-community.github.io/nixvim/plugins/conform-nvim/settings/index.html
    settings = {
      notify_on_error = true;
      notify_no_formatters = true;
      log_level = "warn";
      formatters_by_ft = {
        nix = [
          "nixfmt-rfc-style"
          "alejandra"
        ];
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        html = [
          "prettierd"
        ];
        javascript = [ "deno_fmt" ];
        typescript = [ "deno_fmt" ];
        markdown = [ "deno_fmt" ];
        cpp = [ "clang_format" ];
        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];
      };
      format_after_save = # Lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_fallback = true }
          end
        '';

      # format_on_save = # Lua
      #   ''
      #     function(bufnr)
      #       if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      #         return
      #       end

      #       if slow_format_filetypes[vim.bo[bufnr].filetype] then
      #         return
      #       end

      #       local function on_format(err)
      #         if err and err:match("timeout$") then
      #           slow_format_filetypes[vim.bo[bufnr].filetype] = true
      #         end
      #       end

      #       return { timeout_ms = 200, lsp_fallback = true }, on_format
      #      end
      #   '';

      # formatters = {
      #   shellcheck = {
      #     command = lib.getExe pkgs.shellcheck;
      #   };
      #   shfmt = {
      #     command = lib.getExe pkgs.shfmt;
      #   };
      #   shellharden = {
      #     command = lib.getExe pkgs.shellharden;
      #   };
      #   squeeze_blanks = {
      #     command = lib.getExe' pkgs.coreutils "cat";
      #   };
      # };

    };
  };
}
