{ pkgs
, modulesPath
, lib
, ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
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
  networking.hostName = "nekopon";

  # Other software
  environment.systemPackages = with pkgs; [
    # Misc
    ArchiSteamFarm
  ];

  # xkom telegram bot
  services.xkomhotshot.enable = true;

  # Quassel Core
  services.quassel = {
    enable = true;
    interfaces = [ "0.0.0.0" ];
  };
  systemd.services.quassel.after = [ "network-online.target" ];

  # AdGuard Home
  services.adguardhome = {
    enable = true;
    mutableSettings = false;
    settings = {
      bind_host = lib.mkForce "0.0.0.0";
      users = [
        {
          name = "nat";
          password = "$2a$10$uReUx/0kpqiya/DnTS51ZeN1h5UBXQroKxl3UrPnMl/xdq1.EllL2";
        }
      ];
      dns = {
        port = 53;
        bind_host = "0.0.0.0";
        enable_dnssec = true;
        ratelimit = 0;
        statistics_interval = 0;
        querylog_enabled = false;
        bootstrap_dns = [
          "9.9.9.10"
          "149.112.112.10"
          "2620:fe::10"
          "2620:fe::fe:10"
        ];
        upstream_dns = [
          "https://dns10.quad9.net/dns-query"
        ];
      };
      filters = [
        {
          enabled = true;
          url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
        }
        {
          enabled = true;
          url = "https://adaway.org/hosts.txt";
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/GameConsoleAdblockList.txt";
        }
        {
          enabled = true;
          url = "https://hole.cert.pl/domains/domains.txt";
        }
        {
          enabled = true;
          url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        }
      ];
    };
  };
}
