{
  config,
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.impermanence.nixosModule
    ../../modules/zfs.nix
    ./storage.nix

    ../../presets/desktop.nix
    ../../modules/user-nat.nix
    ../../modules/logitech.nix
    ../../modules/virtualization.nix
    ../../modules/android.nix
    ../../modules/anime4k.nix

    ./media.nix
  ];

  # Bootloader/Kernel/Modules
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = ["amdgpu"];
    };
    extraModulePackages = [config.boot.kernelPackages.rtl8821cu];
    kernelModules = ["kvm-intel" "8821cu"];
  };

  # Misc
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  networking = {
    useDHCP = lib.mkDefault false;
    hostName = "blahaj";
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  system.autoUpgrade.enable = false;
  services.xserver.displayManager.gdm.autoSuspend = false;

  environment.systemPackages = with pkgs; [
    pcsx2 # ps2 emu
  ];

  # MERKUSYS wifi dongle workaround
  services.udev.extraRules = ''
    ATTR{idVendor}=="0bda", ATTR{idProduct}=="1a2b", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -K -v 0bda -p 1a2b"
  '';

  # AMD GPU Overclocking
  boot.kernelParams = ["amdgpu.ppfeaturemask=0xffffffff"];
}
