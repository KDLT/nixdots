{ username, ... }:
{
  home-manager.users.${username}.programs = {
    kitty = {
      enable = true;
      font = {
        name = "CommitMono Nerd Font";
      };

      # Eye-friendly theme options (uncomment one to test)
      # For full theme list, see: https://github.com/kovidgoyal/kitty-themes/tree/master/themes
      # (Use filename without .conf extension for themeFile value)
      # There should also be a reference file in ~/.config/kitty/kitty-themes-reference.txt

      # themeFile = "Nightfox";
      # themeFile = "Carbonfox"; #apparently kulelat nixpkgs, carbonfox has not been added yet (commit is a year old come on)
      # themeFile = "gruvbox-dark";
      # themeFile = "gruvbox-dark-soft";           # Softer contrast version
      # themeFile = "gruvbox-dark-hard";           # Higher contrast version
      # themeFile = "GruvboxMaterialDarkHard"; # Dark hard with softer contrast
      # themeFile = "GruvboxMaterialDarkMedium";   # Dark medium
      # themeFile = "GruvboxMaterialDarkSoft";     # Dark soft
      themeFile = "Catppuccin-Mocha"; # Dark with purple tones
      # themeFile = "Catppuccin-Macchiato";        # Slightly lighter dark
      # themeFile = "Catppuccin-Frappe";           # Medium dark with cooler tones
      # themeFile = "tokyo_night_night"; # Darkest Tokyo Night
      # themeFile = "tokyo_night_storm";           # Balanced Tokyo Night
      # themeFile = "tokyo_night_moon";            # Softer Tokyo Night

      settings = {
        font_size = 20;
        window_padding_width = 12;
        background_opacity = "0.95"; # Slightly more opaque for better readability
        background_blur = 20;
        hide_window_decorations = "titlebar-only"; # hides title bar but not window border

        # Override background to be darker than default Catppuccin-Mocha (#1E1E2E)
        # Uncomment one to test (from slightly darker to pure black):
        background = "#14141F";  # Medium dark - good balance
        # background = "#11111B";  # Quite dark
        # background = "#0E0E17";  # Very dark
        # background = "#000000";  # Pure black (if you want maximum darkness)

        # tab settings
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
      };
    };
  };
}
