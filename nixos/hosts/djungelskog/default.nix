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
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  networking = {
    useDHCP = lib.mkDefault false;
    hostName = "djungelskog";
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # GPU
  hardware.opengl.extraPackages = with pkgs; [vaapiIntel];
  environment.variables = {MESA_LOADER_DRIVER_OVERRIDE = "crocus";};

  # Personal preference on how logind should handle lid switch.
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
  };
}
