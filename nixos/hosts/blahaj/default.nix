{
  config,
  inputs,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    # Hardware
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-cpu-intel-cpu-only
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd

    # Storage
    inputs.impermanence.nixosModule
    ../../modules/zfs.nix
    ./storage.nix

    # Userland
    ../../presets/desktop.nix
    ../../modules/user-nat.nix
    ../../modules/logitech.nix
    ../../modules/virtualization.nix
    ../../modules/android.nix
    ../../modules/anime4k.nix

    # Device specific
    ./media.nix
  ];

  # Bootloader/Kernel/Modules
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
    extraModulePackages = [config.boot.kernelPackages.rtl8821cu];
    kernelModules = ["kvm-intel" "8821cu"];
  };

  # Misc
  networking.hostName = "blahaj";
  system.autoUpgrade.enable = false;
  services.xserver.displayManager.gdm.autoSuspend = false;

  # MERKUSYS wifi dongle workaround
  services.udev.extraRules = ''
    ATTR{idVendor}=="0bda", ATTR{idProduct}=="1a2b", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -K -v 0bda -p 1a2b"
  '';
}
