{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/hardened.nix")
    ../common-pc.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [config.boot.kernelPackages.broadcom_sta];

  boot.initrd.luks.devices = {
    "apricot" = {
      device = "/dev/disk/by-uuid/b148d5cd-93d5-4466-b186-974674fc6e0a";
      allowDiscards = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/c2ddb6eb-a2e7-4577-a369-12a53e7e5a19";
    fsType = "ext4";
    options = [
      "noatime"
      "discard"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/72EE-43DD";
    fsType = "vfat";
    options = [
      "noatime"
      "discard"
    ];
  };

  swapDevices = [];
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
  networking = {
    useDHCP = lib.mkDefault false;
    hostName = "apricot";
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # VAAPI
  hardware.opengl.extraPackages = with pkgs; [vaapiIntel];

  # Personal preference on how logind should handle lid switch.
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "lock";
  };
}
