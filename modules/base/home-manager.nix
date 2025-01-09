{
  username,
  stateVersion,
  pkgs,
  ...
}:{
  # the following home-manager declarations are shared by nixos and nix-darwin
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      home = {
        stateVersion = stateVersion;
        username = username;
        homeDirectory = if pkgs.stdenv.hostPlatform.isLinux then
            "/home/${username}"
          else
            "/Users/${username}";
        sessionPath = [ "$HOME/.local/bin" ];

        packages = with pkgs; [
          libnotify # sends desktop notifs to notif daemon

          fzf # command line fuzzy finder written in go
          ripgrep # better grep entire directories
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
  };
}
