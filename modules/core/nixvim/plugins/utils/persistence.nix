# https://nix-community.github.io/nixvim/plugins/persistence.html
# automatically save sessions under ~/.local/state/nvim/sessions
{
  programs.nixvim.plugins = {
    persistence = {
      # enable = true;
      enable = false;
      saveEmpty = false;
      dir = {
        __raw = "vim.fn.expand(vim.fn.stdpath(\"state\") .. \"/sessions/\")";
      };
    };
  };

  # just straight up commenting these out after disabling nixvim persistence
  # programs.nixvim.keymaps = [
  #   {
  #     mode = "n";
  #     key = "<leader>qs";
  #     action = {
  #       __raw = "function() require(\"persistence\").load() end";
  #     };
  #     options = {
  #       silent = true;
  #       desc = "Load session for current directory";
  #     };
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>qS";
  #     action = {
  #       __raw = "function() require(\"persistence\").select() end";
  #     };
  #     options = {
  #       silent = true;
  #       desc = "Select a session to load";
  #     };
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>ql";
  #     action = {
  #       __raw = "function() require(\"persistence\").load({ last = true }) end";
  #     };
  #     options = {
  #       silent = true;
  #       desc = "Load the last session";
  #     };
  #   }
  #   {
  #     mode = "n";
  #     key = "<leader>qd";
  #     action = {
  #       __raw = "function() require(\"persistence\").stop() end";
  #     };
  #     options = {
  #       silent = true;
  #       desc = "Stop persistence => session won't be saved on exit";
  #     };
  #   }
  # ];
}
