{ username, ... }:
{
  home-manager.users.${username}.programs = {
    kitty = {
      enable = true;
      settings = {
        font_size = 20;
        window_padding_width = 12;
        background_opacity = "0.89";
        background_blur = 20;
        hide_window_decorations = "titlebar-only"; # hides title bar but not window border
        # tab settings
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
      };
    };
  };
}
