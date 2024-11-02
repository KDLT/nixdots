{
  programs.nixvim.plugins.bufferline = {
    enable = true;
    settings = {

    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<S-l>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Cycle to Next Buffer";
    }
    {
      mode = "n";
      key = "<S-h>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Cycle to Previous Buffer";
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>BufferLineCloseOthers<CR>";
      options.desc = "Close every other except the visible one";
    }
    # TODO: the rest the relevant bufferline keymaps
  ];
}
