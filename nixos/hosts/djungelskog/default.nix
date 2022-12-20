{
  config,
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    # Hardware
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t440p
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd

    # Storage
    inputs.impermanence.nixosModule
    ../../modules/zfs.nix
    ./storage.nix

    # Userland
    ../../presets/laptop.nix
    ../../modules/user-nat.nix
  ];

  # Bootloader/Kernel/Modules
  boot = {
    loader.grub = {
      enable = true;
      version = 2;
      device = "/dev/disk/by-id/ata-IR-SSDPR-S25A-240_GU2036937";
    };
    initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc"];
    kernelModules = ["kvm-intel"];
  };

  # Misc
  networking.hostName = "djungelskog";

  # GPU
  environment.variables = {MESA_LOADER_DRIVER_OVERRIDE = "crocus";};
}
