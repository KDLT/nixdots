{
  lib,
  username,
  pkgs,
  config,
  ...
}:
{
  environment.systemPackages = [ pkgs.tmux ];

  # programs.tmux attributeset below is not compatible with nix-darwin
  # lib.optionalAttrs will only allow reading of the attributes if it evaluates to true
  programs.tmux = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    keyMode = "vi"; # vi keybindings
    baseIndex = 1; # index starts at 1 instead of 0
    escapeTime = 250; # default 500
    clock24 = true; # 24h clock
    historyLimit = 100000;
    shortcut = "Space"; # Ctrl followed by this key will be the tmux "leader key"
    extraConfig = '''';
  };

  # i still want home-manager to define the rest of the tmux config
  home-manager.users.${username} = {
    programs.tmux = {
      enable = true;
      keyMode = "vi";
      baseIndex = 1;
      mouse = true; # mouse support
      historyLimit = 100000;
      newSession = true; # automatically spawn new session when trying to attach but none running
      shortcut = "Space";
      clock24 = true;
      extraConfig = ''
        # re-source the config
        unbind r
        bind r source-file ~/.config/tmux/tmux.conf \; display "Tmux Reloaded!"

        # number adjusts when deleting windows
        set -g renumber-windows on

        # preserve path within the current session
        bind c new-window -c "#{pane_current_path}"

        # vim-like pane navigation
        bind-key h select-pane -L
        bind-key j select-pane -D
        bind-key k select-pane -U
        bind-key l select-pane -R

        # rebind vertical and horizontal split
        bind-key "|" split-window -h -c "#{pane_current_path}"
        bind-key "-" split-window -v -c "#{pane_current_path}"

        # transfer tmux status bar to top
        # set-option -g status-position top
      '';

      plugins = with pkgs.tmuxPlugins; [
        cpu
        # catppuccin
        # dracula
        tmux-floax
        {
          # consistent pane navigation between tmux and neovim
          # needs setup on neovim side, too
          plugin = vim-tmux-navigator;
          extraConfig = ''
            set -g @plugin 'christoomey/vim-tmux-navigator'
            set -g @vim_navigator_mapping_left "C-Left C-h"  # use C-h and C-Left
            set -g @vim_navigator_mapping_right "C-Right C-l"
            set -g @vim_navigator_mapping_up "C-k"
            set -g @vim_navigator_mapping_down "C-j"
            set -g @vim_navigator_mapping_prev ""  # removes the C-\ binding
          '';
        }
        {
          plugin = tokyo-night-tmux;
          extraConfig = ''
            set -g @tokyo-night-tmux_window_id_style none
            set -g @tokyo-night-tmux_pane_id_style hsquare
            set -g @tokyo-night-tmux_zoom_id_style dsquare
          '';
        }
        {
          # prefix, ctrl-s to save; prefix, ctrl-r to reload
          plugin = resurrect;
          # explicityly state resurrect-dir
          extraConfig = ''
            resurrect_dir="~/.config/tmux/resurrect"

            # for neovim
            set -g @resurrect-strategy-nvim 'session'

            set -g @resurrect-dir $resurrect_dir
            set -g @resurrect-processes 'ssh btop'

            # post save hook
            # this relies on nixos wrapper for nvim resurrect to start with /nix/store and end with -init.lua
            set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s|/nix/store/.*-init.lua|nvim|g" $target | sponge $target'
          '';
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60'
          '';
        }
      ];
    };
  };
}
