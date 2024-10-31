{...}: let
  schemeName = "tokyonight";
  # schemeName = "catppuccin";
  # schemeName = "dracula-nvim";
  # schemeName = "kanagawa";
  # schemeName = "palette";
  # schemeName = "onedark";
in {
  programs.nixvim.colorschemes = {
    # even if this is enabled, stylix takes over
    "${schemeName}" = {
      enable = true;
      settings = {
        transparent = true; # uncomment for tokyonight, kanagawa, onedark
        # transparent_background = true; # uncomment for catppuccin, pallette
        # transparent_bg = true; # uncomment for draculanvim
      };
    };
  };
}
