{
  lib,
  pkgs,
  ...
}:
{
  ### now declared in ~/dotfiles/modules/storage/impermanence/default.nix
  ## https://discourse.nixos.org/t/zfs-rollback-not-working-using-boot-initrd-systemd/37195/2
  # boot.initrd.systemd.enable = lib.mkDefault true;
  # boot.initrd.systemd.services.rollback = {
  #   description = "Rollback root filesystem to blank state";
  #   wantedBy = [ "initrd.target" ];
  #   after = [ "zfs-import-rpool.service" ];
  #   before = [ "sysroot.mount" ];
  #   path = [ pkgs.zfs ];
  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";
  #   script = ''
  #     zfs rollback -r rpool/local/root@blank && echo " >> >> rollback complete << <<"
  #   '';
  # };

  ### now declared in ~/dotfiles/modules/storage/impermanence/default.nix
  # fileSystems."/data".neededForBoot = true;
  #
  # environment.persistence."/data" = {
  #   hideMounts = true;
  #   directories = [
  #     "/etc/nixos"
  #     "/var/log"
  #     "/var/lib/bluetooth"
  #     "/var/lib/nixos"
  #     "/var/lib/systemd/coredump"
  #     "/etc/NetworkManager/system-connections"
  #     {
  #       directory = "/var/lib/colord";
  #       user = "colord";
  #       group = "colord";
  #       mode = "u=rwx,g=rx,o=";
  #     }
  #   ];
  #   files = [
  #     "/etc/machine-id"
  #     {
  #       file = "/var/keys/secret_file";
  #       parentDirectory = {
  #         mode = "u=rwx,g=,o=";
  #       };
  #     }
  #   ];
  #
  #   # either this or the home.persistence approach
  #   users.kba = {
  #     directories = [
  #       "Downloads"
  #       "Music"
  #       "Pictures"
  #       "Documents"
  #       "Videos"
  #       "dotfiles"
  #       "code"
  #       {
  #         directory = ".ssh";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".mozilla";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".config";
  #         mode = "0700";
  #       }
  #       {
  #         directory = ".local/share";
  #         mode = "0700";
  #       }
  #     ];
  #     files = [
  #       ".screenrc"
  #     ];
  #   };
  # };

  # fileSystems."/cache".neededForBoot = true;
  # environment.persistence."/cache" = {
  #   users.kba = {
  #     directories = [
  #       ".cache/epiphany"
  #       ".cache/mozilla"
  #       ".cache/tracker3"
  #       ".cache/mesa_shader_cache_db"
  #     ];
  #   };
  # };

  # zfs
  # boot = {
  #   supportedFilesystems = ["zfs"];
  #   zfs.devNodes = "/dev/";
  # };
}
