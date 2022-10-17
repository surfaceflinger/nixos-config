{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../common-pc.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel and modules
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = ["amdgpu"];
  boot.kernelModules = ["kvm-intel" "8821cu"];
  boot.extraModulePackages = [config.boot.kernelPackages.rtl8821cu];

  boot.initrd.luks.devices = {
    "sparkle" = {
      device = "/dev/disk/by-uuid/d9907dfb-a0a3-4717-836e-da15d8e95eb7";
      allowDiscards = true;
    };
    "SSD2" = {
      device = "/dev/disk/by-uuid/1cdf5025-4e71-47be-86be-23d2daf75613";
      allowDiscards = true;
    };
    "HDD" = {
      device = "/dev/disk/by-uuid/a5976932-830d-470d-8cb1-494ead3feda4";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/50dcc5fd-33f3-40a6-854a-41050068dcd2";
    fsType = "ext4";
    options = [
      "noatime"
      "discard"
    ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C558-15A5";
    fsType = "vfat";
    options = [
      "noatime"
      "discard"
    ];
  };

  fileSystems."/media/ssd2" = {
    device = "/dev/disk/by-uuid/1eaeb337-6f3e-4097-85b6-baf5eb45483e";
    fsType = "ext4";
    options = [
      "noatime"
      "discard"
    ];
  };

  fileSystems."/media/hdd" = {
    device = "/dev/disk/by-uuid/cec58783-0ef2-46c3-a855-ec413653ca77";
    fsType = "ext4";
    options = [
      "noatime"
    ];
  };

  swapDevices = [];
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  networking = {
    useDHCP = lib.mkDefault false;
    hostName = "sparkle";
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # MERKUSYS wifi dongle workaround
  services.udev.extraRules = ''
    ATTR{idVendor}=="0bda", ATTR{idProduct}=="1a2b", RUN+="${pkgs.usb-modeswitch}/bin/usb_modeswitch -K -v 0bda -p 1a2b"
  '';

  # FreeSync
  services.xserver.deviceSection = ''
    Option "VariableRefresh" "true"
  '';
}
