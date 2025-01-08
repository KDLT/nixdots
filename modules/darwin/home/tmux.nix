{ username, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    enableMouse = true;
    enableVim = true;
    enableFzf = true;
    enableSensible = true;
    # extraConfig = ''
    #   unbind r
    #   bind r source-file ~/.config/tmux/tmux.conf \; display "Tmux Reloaded!";
    # '';
  };

  # home-manager.users.${username} = {
  #   programs.tmux = {
  #     enable = true;
  #     keyMode = "vi";
  #     baseIndex = 1;
  #     mouse = true; # mouse support
  #     historyLimit = 100000;
  #     newSession = true; # automatically spawn new session when trying to attach but none running
  #     shortcut = "Space";
  #     clock24 = true;
  #     extraConfig = ''
  #       # shell is reverting to bash on Mac
  #       set-option -g default-shell ${pkgs.zsh}
  #
  #       # re-source the config
  #       unbind r
  #       bind r source-file ~/.config/tmux/tmux.conf \; display "Tmux Reloaded!"
  #
  #       # number adjusts when deleting windows
  #       set -g renumber-windows on
  #
  #       # preserve path within the current session
  #       bind c new-window -c "#{pane_current_path}"
  #
  #       # vim-like pane navigation
  #       bind-key h select-pane -L
  #       bind-key j select-pane -D
  #       bind-key k select-pane -U
  #       bind-key l select-pane -R
  #
  #       # rebind vertical and horizontal split
  #       bind-key "|" split-window -h -c "#{pane_current_path}"
  #       bind-key "-" split-window -v -c "#{pane_current_path}"
  #
  #       # transfer tmux status bar to top
  #       # set-option -g status-position top
  #     '';
  #
  #     # tmuxinator.enable = true; # the session manager with more stars
  #     # tmuxp.enable = true; # tmux session manager with less stars
  #
  #     plugins = with pkgs.tmuxPlugins; [
  #       cpu
  #       # catppuccin
  #       # dracula
  #       tmux-floax
  #       {
  #         # consistent pane navigation between tmux and neovim
  #         # needs setup on neovim side, too
  #         plugin = vim-tmux-navigator;
  #         extraConfig = ''
  #           set -g @plugin 'christoomey/vim-tmux-navigator'
  #           set -g @vim_navigator_mapping_left "C-Left C-h"  # use C-h and C-Left
  #           set -g @vim_navigator_mapping_right "C-Right C-l"
  #           set -g @vim_navigator_mapping_up "C-k"
  #           set -g @vim_navigator_mapping_down "C-j"
  #           set -g @vim_navigator_mapping_prev ""  # removes the C-\ binding
  #         '';
  #       }
  #       {
  #         plugin = tokyo-night-tmux;
  #         extraConfig = ''
  #           set -g @tokyo-night-tmux_window_id_style none
  #           set -g @tokyo-night-tmux_pane_id_style hsquare
  #           set -g @tokyo-night-tmux_zoom_id_style dsquare
  #         '';
  #       }
  #       {
  #         # prefix, ctrl-s to save; prefix, ctrl-r to reload
  #         plugin = resurrect;
  #         # explicityly state resurrect-dir
  #         extraConfig = ''
  #           resurrect_dir="~/.config/tmux/resurrect"
  #
  #           # for neovim
  #           set -g @resurrect-strategy-nvim 'session'
  #
  #           set -g @resurrect-dir $resurrect_dir
  #           set -g @resurrect-processes 'ssh btop'
  #
  #           # post save hook
  #           # this relies on nixos wrapper for nvim resurrect to start with /nix/store and end with -init.lua
  #           set -g @resurrect-hook-post-save-all 'target=$(readlink -f $resurrect_dir/last); sed "s|/nix/store/.*-init.lua|nvim|g" $target | sponge $target'
  #         '';
  #       }
  #       {
  #         plugin = continuum;
  #         extraConfig = ''
  #           set -g @continuum-restore 'on'
  #           set -g @continuum-save-interval '60'
  #         '';
  #       }
  #     ];
  #   };
  # };
}
