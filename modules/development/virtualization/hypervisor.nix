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
      virtualization.hypervisor.enable = lib.mkEnableOption "Libvirt/KVM";
    };
  };

  config = lib.mkIf config.kdlt.development.virtualization.hypervisor.enable {
    # kdlt.core.zfs.systemCacheLinks = [ "/var/lib/libvirt" ];

    users.users.${config.kdlt.username}.extraGroups = ["libvirtd"];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        verbatimConfig = ''
          nvram = [
            "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd",
            "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"
          ]
        '';
        runAsRoot = false;
      };

      onBoot = "start";
      onShutdown = "shutdown";
    };

    home-manager.users.${config.kdlt.username} = {
      home.packages = [pkgs.virt-manager];
    };
  };
}
