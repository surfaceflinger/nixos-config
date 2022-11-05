{ config
, pkgs
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/hardened.nix")
  ];

  # Bootloader/Kernel/Modules
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 1;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
      kernelModules = [ "nvme" ];
    };
    cleanTmpDir = true;
  };

  # Filesystems
  fileSystems = {
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/sda15";
      fsType = "vfat";
    };
  };

  # Networking
  networking.hostName = "nekopon";

  # Other software
  environment.systemPackages = with pkgs; [
    # Misc
    ArchiSteamFarm
  ];

  # xkom telegram bot
  services.xkomhotshot.enable = true;

  # Quassel Core
  services.quassel = {
    enable = true;
    interfaces = [ "0.0.0.0" ];
  };
  systemd.services.quassel.after = [ "network-online.target" ];
}
