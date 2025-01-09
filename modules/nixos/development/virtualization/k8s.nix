{
  pkgs,
  lib,
  config,
  user,
  ...
}: {
  # i choose to not declare these options here but in ../default.nix instead
  options = {
    kdlt.development = {
      virtualization.k8s.enable = lib.mkEnableOption "k8s tooling";
    };
  };

  config = lib.mkIf config.kdlt.development.virtualization.k8s.enable {
    home-manager.users.${config.kdlt.username} = {
      home.packages = with pkgs; [
        talosctl
        kubectl
        kubernetes-helm
        kustomize
        argocd # this is not an autosuggested package name
        cilium-cli
        kubeseal
      ];

      programs.k9s = {
        enable = true;
      };
    };
  };
}
