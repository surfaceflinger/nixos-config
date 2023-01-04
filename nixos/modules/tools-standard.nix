{ pkgs, ... }: {
  # Other software
  environment.systemPackages = with pkgs; [
    # Rice / UX
    zsh-fast-syntax-highlighting

    # CLI/TUI tools
    binwalk
    deadnix
    file
    magic-wormhole-rs
    nano
    ncdu
    nixpkgs-fmt
    p7zip
    screen
    tree
    wget

    # System utilities
    neofetch
    lm_sensors
    pciutils
    psmisc
    usbutils

    # Networking
    bind
    nload
    whois
  ];

  programs.git.enable = true;
  programs.htop.enable = true;

  programs.nano = {
    syntaxHighlight = true;
    nanorc = ''
      set autoindent
      set tabsize 2
      set tabstospaces
    '';
  };

}
