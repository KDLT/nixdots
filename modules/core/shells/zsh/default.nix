# modules/core/shells/zsh/default.nix
{
  pkgs,
  lib,
  config,
  ...
}:
let
  username = config.kdlt.username;
  graphical = config.kdlt.graphical;
  hyprland = config.kdlt.graphical.hyprland;
  myAliases = {
    ll = "eza --icons=always --color=always --long --group-directories-first --git --no-filesize --no-time --no-permissions --no-user --tree --level=1";
    cat = "bat";
    gitfetch = "onefetch";
    fetch = "disfetch";
    icat = "kitten icat";
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
          zsh.enable = true;
          bash.enable = true;
          fish.enable = false;
          zoxide.enable = true;
          fzf.enable = true;
          thefuck.enable = true;
          direnv.enable = true;
        };

        programs.zsh = {
          dotDir = ".config/zsh"; # path relative to $HOME

          history = {
            size = 10000;
            extended = true; # add timestamps
            path = "$XDG_CONFIG_HOME/zsh/histfile";
            ignoreDups = true; # ignore succeeding duplicates
            ignoreAllDups = true; # ignore all duplicates
          };

          autosuggestion.enable = true;

          initExtraBeforeCompInit = ''
            # set directory for storing zinit and plugins
            ZINIT_HOME="$XDG_DATA_HOME/zinit/zinit.git"
            [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
            [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

            # source/load zinit
            source "$ZINIT_HOME/zinit.zsh"

            # let zinit handle syntax highlight and autocomplete
            zinit light zdharma-continuum/fast-syntax-highlighting
            zinit light marlonrichert/zsh-autocomplete
          '';

          completionInit = ''
            autoload -U compinit && compinit -d $HOME/.config/zsh/zcompdump
          '';

          initExtra = ''
            # match dotfiles without explicitly specifying the dot
            setopt GLOB_DOTS
          '';

          shellAliases = myAliases;

          # envextra is appended to zshenv, this gets called when spawning new terminals
          envExtra = ''${pkgs.disfetch}/bin/disfetch'';
          # loginExtra is prepended to zlogin, this gets called upon login, wow
          loginExtra = lib.mkIf (graphical.enable && hyprland.enable) "${pkgs.hyprland}/bin/Hyprland";
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
