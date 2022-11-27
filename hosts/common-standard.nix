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
    kexAlgorithms = [ "sntrup761x25519-sha512@openssh.com" ];
    ciphers = [ "chacha20-poly1305@openssh.com" ];
    macs = [ "-*" ];
    kbdInteractiveAuthentication = false;
    passwordAuthentication = false;
    permitRootLogin = "no";
    extraConfig = ''
      AllowAgentForwarding no
      AllowUsers {{users}}
      LoginGraceTime 15s
      MaxAuthTries 2
      MaxStartups 4096
      PerSourceMaxStartups 1
      PrintMotd no
      PubkeyAcceptedKeyTypes ssh-ed25519
    '';
    hostKeys = [
      {
        path = "/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];
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
    set autoindent
    set tabsize 2
    set tabstospaces
  '';
}
