{
  config,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    (modulesPath + "/profiles/hardened.nix")
    ../common.nix
    ./web.nix
    ../../misc/xkom/service.nix
  ];

  # Boot/HW
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 1;
    };
    efi.canTouchEfiVariables = true;
  };

  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
  boot.initrd.kernelModules = ["nvme"];
  boot.cleanTmpDir = true;

  # Filesystems
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/sda15";
    fsType = "vfat";
  };

  # zram swap
  zramSwap.enable = true;

  # Networking
  networking.hostName = "nekopon";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [];
    allowedUDPPorts = [config.services.tailscale.port];
    trustedInterfaces = ["tailscale0"];
    checkReversePath = "loose";
  };

  services.tailscale.enable = true;

  # Users
  services.openssh = {
    enable = true;
    openFirewall = true;
    passwordAuthentication = false;
  };

  users.users.nat = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeWbH2L99MoMuT2a1nzmpI86VBht/io2TBraa2Pe98F nat@sparkle"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANRmkBgx14Oa1CKUQfS76V0ixEJzKhHlM8XF7qqiapa nat@apricot"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPyEWk3PXyY4v+KXGkqvz45/Wi4VYYr1A2aU423o54Nc willow"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqJ6aKTV33D1iZcuEw86lQ6QxmcfqIEcpBs4Da7GjI2 hanoip"
    ];
  };

  # Other software
  environment.systemPackages = with pkgs; [
    # Wrappers
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')

    # CLI/TUI tools
    alejandra # nix beautifier (in Rust 🚀)
    nano # vim is useless
    ncdu
    p7zip
    screen # Terminal multiplexer
    tree # List contents of directories in a tree-like format
    unrar
    unzip
    wget # Retrieving files using HTTP, HTTPS, FTP and FTPS

    # System utilities
    htop # TUI task manager
    neofetch # Command-line system information tool
    pciutils
    psmisc # killall

    # Development
    gitFull # Distributed version control
    gnupg # To encrypt DMs on WHM

    # Networking
    bind # nslookup/dig
    nload
    nmap # port scanning

    # Misc
    ArchiSteamFarm
  ];

  # xkom telegram bot
  services.xkomhotshot.enable = true;

  # Quassel Core
  services.quassel = {
    enable = true;
    interfaces = ["0.0.0.0"];
  };

  system.stateVersion = "22.11";
}
