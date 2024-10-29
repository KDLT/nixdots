# ~/dotfiles/modules/core/home-manager/default.nix
{
  config,
  pkgs,
  ...
}:
let
  username = config.kdlt.username;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users = {
      ${username} = {
        # imports = [ inputs.catppuccin.homeManagerModules.catppuccin ];
        home = {
          stateVersion = config.kdlt.stateVersion;

          homeDirectory = "/home/${username}";

          packages = with pkgs; [
            libnotify # sends desktop notifs to notif daemon
            wireguard-tools # secure tunneling whatever that means
            ventoy # endgame bootable usb

            fzf # command line fuzzy finder written in go
            ripgrep
            gcc # gnu compiler collection
            fd # alternative to find
            xclip # tool to access clipboard from console
            oh-my-posh # prompt engine
            fortune # pseudorandom message generator
            cowsay # generates ascii picture of cow with message
            lolcat # rainbow cat
            onefetch # git repository summary from terminal
          ];
        };
      };

      root = _: {
        # the underscore colon _: might just be the same as {...}:
        home.stateVersion = config.kdlt.stateVersion;
      };
    };
  };
}
