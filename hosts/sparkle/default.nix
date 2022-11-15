{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # Bootloader/Kernel/Modules
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ "amdgpu" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    extraModulePackages = [ config.boot.kernelPackages.rtl8821cu ];
    kernelModules = [ "kvm-intel" "8821cu" ];
  };

  # LUKS
  boot.initrd.luks.devices = {
    "sparkle" = {
      device = "/dev/disk/by-uuid/d9907dfb-a0a3-4717-836e-da15d8e95eb7";
      allowDiscards = true;
    };
    "ssd2" = {
      device = "/dev/disk/by-uuid/1cdf5025-4e71-47be-86be-23d2daf75613";
      allowDiscards = true;
    };
    "hdd" = {
      device = "/dev/disk/by-uuid/a2cda069-46d4-49c8-ae91-b9188a261760";
    };
  };

  # Filesystems
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/50dcc5fd-33f3-40a6-854a-41050068dcd2";
      fsType = "ext4";
      options = [
        "noatime"
        "discard"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/C558-15A5";
      fsType = "vfat";
      options = [
        "noatime"
        "discard"
      ];
    };
    "/media/ssd2" = {
      device = "/dev/disk/by-uuid/1eaeb337-6f3e-4097-85b6-baf5eb45483e";
      fsType = "ext4";
      options = [
        "noatime"
        "discard"
      ];
    };
    "/media/hdd" = {
      device = "/dev/disk/by-uuid/d33701e3-0e42-472f-9326-ea93a3d79f1a";
      fsType = "ext4";
      options = [
        "noatime"
      ];
    };
  };

  # minidlna
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      inotify = "yes";
      media_dir = [ "V,/media/hdd/Torrent/DL" ];
      friendly_name = config.networking.hostName;
    };
  };

  # Misc
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

  # AMD Overclocking
  boot.kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];

  # Disable autoupgrade
  system.autoUpgrade.enable = false;

  # Extra packages
  environment.systemPackages = with pkgs; [
    pcsx2 # ps2 emu
  ];
}
