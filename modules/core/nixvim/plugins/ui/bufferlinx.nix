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
    # TODO: the rest the relevant bufferline keymaps
  ];
}
