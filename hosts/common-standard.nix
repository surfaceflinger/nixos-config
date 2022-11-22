{ config
, pkgs
, ...
}: {
  # Networking
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ config.services.tailscale.port ];
    trustedInterfaces = [ "tailscale0" ];
    checkReversePath = "loose";
  };
  services.tailscale.enable = true;

  # Users
  services.openssh = {
    enable = true;
    openFirewall = true;
    passwordAuthentication = false;
  };

  # Other software
  environment.systemPackages = with pkgs; [
    # Rice / UX
    zsh-fast-syntax-highlighting # Syntax highlighting for zsh

    # CLI/TUI tools
    alejandra # nix beautifier (in Rust 🚀)
    deadnix
    nano # vim is useless
    ncdu
    nixpkgs-fmt
    p7zip
    screen # Terminal multiplexer
    tree # List contents of directories in a tree-like format
    unrar
    unzip
    wget # Retrieving files using HTTP, HTTPS, FTP and FTPS

    # System utilities
    config.boot.kernelPackages.cpupower # Manage cpu governor and few other cool things
    dmidecode
    htop # TUI task manager
    lm_sensors
    neofetch # Command-line system information tool
    pciutils
    psmisc # killall
    spectre-meltdown-checker # Check if mitigations=off worked in style
    usbutils # why, why isnt my pendrive working????? i have hardened profile btw

    # Development
    gitFull # Distributed version control
    gnupg # To encrypt DMs on WHM

    # Networking
    bind # nslookup/dig
    nload
    nmap # port scanning
  ];

  programs.nano.nanorc = ''
    set tabsize 2
    set tabstospaces
    set autoindent
  '';

  # Hardened profile fixes/overrides/additions
  security = {
    lockKernelModules = false;
    unprivilegedUsernsClone = true;
  };
}
