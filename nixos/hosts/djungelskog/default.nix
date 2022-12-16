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
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    inputs.nixos-hardware.nixosModules.common-cpu-intel
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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci"];
    kernelModules = ["kvm-intel"];
  };

  # Misc
  networking.hostName = "djungelskog";

  # GPU
  environment.variables = {MESA_LOADER_DRIVER_OVERRIDE = "crocus";};
}
