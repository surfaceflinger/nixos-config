{ pkgs
, inputs
, modulesPath
, ...
}: {
  imports = [
    # Hardware
    (modulesPath + "/profiles/qemu-guest.nix")

    # Storage
    ../../modules/zfs.nix
    ./storage.nix

    # Userland
    ../../presets/server.nix
    ../../modules/user-nat.nix

    inputs.xkomhotshot.nixosModule
    ./adguard.nix
    ./quassel.nix
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
  networking.hostName = "blavingad";

  # Other software
  environment.systemPackages = with pkgs; [
    # Misc
    ArchiSteamFarm
  ];

  # xkom telegram bot
  services.xkomhotshot.enable = true;
}
