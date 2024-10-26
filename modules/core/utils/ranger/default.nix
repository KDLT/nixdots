# ~/dotfiles/modules/core/utils/ranger/default.nix
{config, ...}: {
  config = {
    home-manager.users.${config.kdlt.username} = {
      programs.ranger = {
        enable = true;
        extraConfig = ''
          # set preview_images true
        '';
        settings = {
          column_ratios = "1,3,3";
          scroll_offset = 8;
          unicode_ellipsis = true;
          preview_images = true;
          preview_images_method = "kitty";
        };
      };
    };
  };
}
