# modules/core/shells/zsh/default.nix
{
  lib,
  username,
  pkgs,
  config,
  ...
}:
let
  myAliases = {
    ll = "eza --icons=always --color=always --long --group-directories-first --git --no-filesize --no-time --no-permissions --no-user --tree --level=1";
    lg = "lazygit";
    cat = "bat";
    gitfetch = "onefetch";
    fetch = "fastfetch";
    icat = "kitten icat";
    dots = "z ~/nixdots; v"; # z is alias for zoxide, v is for neovim
  };
in
{
  options = { };
  config = {
    # kdlt.core.zfs = lib.mkMerge [
    #   (lib.mkIf config.kdlt.core.persistence.enable {
    #     systemCacheLinks = ["/root/.local/share/autojump"];
    #     homeCacheLinks = [".local/share/autojump"];
    #   })
    # ];

    programs.zsh.enable = true;

    home-manager.users = {
      ${username} = {
        home.packages = with pkgs; [
          comma # run package without installing them
          onefetch # git repo summary on terminal
          disfetch # less complex neofetch
        ];

        programs = {
          bash.enable = false;
          fish.enable = false;
          zoxide.enable = true;
          fzf.enable = true;
          direnv.enable = true;
        };

        programs.zsh = {
          enable = true;
          # dotDir = ".config/zsh"; # path relative to $HOME # now deprecated

          history = {
            size = 10000;
            extended = true; # add timestamps
            path = "$XDG_CONFIG_HOME/zsh/histfile";
            ignoreDups = true; # ignore succeeding duplicates
            ignoreAllDups = true; # ignore all duplicates
          };

          # Disable home-manager's autosuggestion to avoid conflict with zsh-autocomplete
          autosuggestion.enable = false;

          initContent = lib.mkMerge [
            (lib.mkOrder 550 ''
              # set directory for storing zinit and plugins
              ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
              [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
              [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

              # source/load zinit
              source "$ZINIT_HOME/zinit.zsh"

              # Performance tuning for zsh-autocomplete to prevent high CPU usage
              zstyle ':autocomplete:*' delay 0.1  # slight delay before fetching completions
              zstyle ':autocomplete:*' min-input 2  # require 2 chars before showing completions
              zstyle ':autocomplete:*' timeout 1.0  # max 1 second wait for completion

              # Load zsh-autocomplete FIRST (creates ZLE widgets)
              zinit light marlonrichert/zsh-autocomplete

              # Load syntax highlighting AFTER autocomplete
              # Redirect stderr to suppress harmless widget warnings from fast-syntax-highlighting
              zinit light zdharma-continuum/fast-syntax-highlighting 2>/dev/null

              # Docker completion from official repo
              zinit ice as"completion"
              zinit snippet https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
            '')
            (lib.mkOrder 1000 ''
              # match dotfiles without explicitly specifying the dot
              setopt GLOB_DOTS
              # runs disfetch on new terminal instances
              # ${pkgs.disfetch}/bin/disfetch
              ${pkgs.fastfetch}/bin/fastfetch
            '')
          ];

          # Remove completionInit - zsh-autocomplete handles compinit internally
          # Having both causes conflicts and can lead to performance issues
          completionInit = "";

          shellAliases = myAliases;

          # loginExtra is PREpended to zlogin, this gets called upon login, wow
          # commented out in favor of uwsm = universal wayland session manager
          # loginExtra = lib.mkIf (graphical.enable && hyprland.enable) "${pkgs.hyprland}/bin/Hyprland";
        };

        programs.bash = {
          shellAliases = myAliases;
        };
        programs.fish = {
          shellAliases = myAliases;
        };
      };
    };
  };
}
