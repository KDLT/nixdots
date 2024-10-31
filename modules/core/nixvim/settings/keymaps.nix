{
  config,
  lib,
  ...
}:
{
  # keymaps.nix
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # keymaps is list of submodules [ {} {} {} ... ]
    # keymaps = [
    #   {
    #     action = "<cmd>make<CR>";
    #     key = "<C-m>";
    #     options = {
    #       silent = true;
    #       desc = "";
    #     };
    #   }
    # ];
    #### Pending: add descriptions inside the mapAttrsToList
    keymaps =
      let
        # mappings on normal mode
        normal =
          # lib.mapAttrsToList (key: action: {
          # keyset = { key = "inputkey"; action = "desiredoutput"; "desc" = "descriptive text" };
          lib.mapAttrsToList
            (key: keyAttrs: {
              mode = "n";
              options = {
                desc = keyAttrs.desc;
              };
              # inherit action key; # stopped using this because i want to add description
              key = key;
              action = keyAttrs.action;
            })
            {
              "<Space>" = {
                action = "<NOP>";
                desc = "Global Leader Key";
              };
              "<Esc>" = {
                action = ":noh<CR>";
                desc = "clear highlights";
              };
              "L" = {
                action = "$";
                desc = "go to last character of line";
              };
              "H" = {
                action = "^";
                desc = "go to first non-empty character of line";
              };

              "<leader><F7>" = {
                action = "gg=G";
                desc = "Auto-indent Current Buffer";
              };

              "<C-c>" = {
                action = ":b#<CR>";
                desc = "back and forth between two most recent buffers";
              };
              "<C-x>" = {
                action = ":close<CR>";
                desc = "close window via Ctrl+x, this cannot close the last window";
              };

              "<leader>s" = {
                action = ":w<CR>";
                desc = "Save Buffer";
              };
              "<C-s>" = {
                action = ":w<CR>";
                desc = "Save Buffer";
              };

              "<leader>h" = {
                action = "<C-w>h";
                desc = "Navigate to Left window";
              };
              "<leader>j" = {
                action = "<C-w>j";
                desc = "Navigate to Bottom window";
              };
              "<leader>k" = {
                action = "<C-w>k";
                desc = "Navigate to Top window";
              };
              "<leader>l" = {
                action = "<C-w>l";
                desc = "Navigate to Right window";
              };

              "<C-Up>" = {
                action = ":resize +2<CR>";
                desc = "grow horizontal current window";
              };
              "<C-Down>" = {
                action = ":resize -2<CR>";
                desc = "shrink horizontal current window";
              };
              "<C-Left>" = {
                action = ":vertical resize -2<CR>";
                desc = "shrink vertical current window";
              };
              "<C-Right>" = {
                action = ":vertical resize +2<CR>";
                desc = "grow vertical current window";
              };
            };

        # mappings on visual mode
        visual =
          lib.mapAttrsToList
            (key: action: {
              mode = "v";
              inherit action key;
            })
            {
              # keeps the highlight intact after indenting
              ">" = ">gv";
              "<TAB>" = ">gv";
              "<" = "<gv";
              "<S-TAB>" = "<gv";

              # move selected line/block of text in visual mode
              "K" = ":m '<-2<CR>gv=gv";
              "J" = ":m '>+1<CR>gv=gv";
            };
      in
      config.lib.nixvim.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual);
  };
}
