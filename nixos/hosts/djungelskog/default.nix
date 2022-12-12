{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

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

  # LUKS
  boot.initrd.luks.devices = {
    "OS" = {
      device = "/dev/disk/by-uuid/b148d5cd-93d5-4466-b186-974674fc6e0a";
      allowDiscards = true;
    };
  };

  # Filesystems
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/c2ddb6eb-a2e7-4577-a369-12a53e7e5a19";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/72EE-43DD";
      fsType = "vfat";
      options = [
        "noatime"
      ];
    };
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
