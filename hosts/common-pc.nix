{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # zram swap
  zramSwap.enable = true;

  # Networking
  networking = {
    networkmanager.enable = true;
  
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [ config.services.tailscale.port ];
      trustedInterfaces = [ "tailscale0" ];
      checkReversePath = "loose";
    };
  };

  time.timeZone = "Europe/Warsaw";

  services.tailscale.enable = true;

  # Locale and keymap
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pl";

  # Desktop environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-console
  ]) ++ (with pkgs.gnome; [
    cheese
    gnome-music
    gedit
    epiphany
    geary
  ]);

  # Sound
  security.rtkit.enable = true;
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Users
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        users = [ "root" ];
        groups = [ "wheel" ];
        keepEnv = true;
        persist = true;
      }];
    };
  };

  programs.zsh.enable = true;

  users.users.nat = {
    isNormalUser = true;
    extraGroups = [ "wheel" "libvirtd" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # Other software
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
    tailscale
    gnomeExtensions.blur-my-shell
    gnomeExtensions.dash-to-panel
    gnomeExtensions.user-themes
    gnomeExtensions.rounded-window-corners
    gnomeExtensions.window-is-ready-remover
    gnomeExtensions.gamemode
    gnomeExtensions.appindicator
    adw-gtk3
    tela-icon-theme
    capitaine-cursors
    cascadia-code
    zsh-fast-syntax-highlighting
    gnome.gnome-tweaks
    gnome.gnome-terminal
    gnome.eog
    lollypop
    glxinfo
    libva-utils
    usbutils
    config.boot.kernelPackages.cpupower
    nano
    wget
    pavucontrol
    spectre-meltdown-checker
    gitFull
    gnupg
    neofetch
    htop
    google-chrome
    tdesktop
    discord
    polymc
    sublime4
    virt-manager
    solaar
    #electrum
    electrum-ltc
    monero-gui
    ledger-live-desktop
    obs-studio
    mpv
    yt-dlp
    radeontop
    qbittorrent
    tree
  ];

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  programs.gamemode.enable = true;
  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.gnupg.agent.enable = true;

  # Chromium config
  nixpkgs.overlays = [
    (self: super: {
     google-chrome = super.google-chrome.override {
       commandLineArgs = "--enable-features=WebUIDarkMode --force-dark-mode";
      };
    })
  ];

  programs.chromium = {
    enable = true;
    extraOpts = {
      "SavingBrowserHistoryDisabled" = true;
      "DefaultJavaScriptJitSetting" = 2;
      "HistoryClustersVisible" = false;
    };
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs
      "omkfmpieigblcllmkgbflkikinpkodlk" # enhanced-h264ify
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies
      "pkehgijcmpdhfbdbbnkijodmdjhbjlgp" # Privacy Badger
      "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube dislike
      "mafpmfcccpbjnhfhjnllmmalhifmlcie" # TOR Snowflake
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
  };

  # Ledger udev rules
  hardware.ledger.enable = true;

  # Hardened profile fixes/overrides/additions
  security = {
    chromiumSuidSandbox.enable = true;
    unprivilegedUsernsClone = true;
    pam.loginLimits = [{ domain = "*"; item = "core"; type = "hard"; value = "0"; }];
  };
  systemd.coredump.enable = false;
  environment.memoryAllocator.provider = "libc";

  # Flakes support
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };

  # stateVersion
  system.stateVersion = "22.11";
}
