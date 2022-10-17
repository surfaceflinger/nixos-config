{
  config,
  pkgs,
  ...
}: let
  mypkgs = import ../packages {inherit pkgs;};
in {
  imports = [
    ./common.nix
  ];

  # kernel args
  boot.kernelParams = ["mitigations=off"];

  # Networking
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [config.services.tailscale.port];
      trustedInterfaces = ["tailscale0"];
      checkReversePath = "loose";
    };
  };

  services.tailscale.enable = true;

  # Desktop environment
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-console
    ])
    ++ (with pkgs.gnome; [
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
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Users
  users.users.nat = {
    extraGroups = ["libvirtd" "networkmanager" "adbusers"];
  };

  # Other software
  environment.systemPackages = with pkgs; [
    # Wrappers
    (pkgs.writeScriptBin "youtube-dl" ''exec yt-dlp "$@"'')

    # Rice / UX
    adw-gtk3 # libadwaita look for gtk3 software
    gnome.gnome-tweaks # App to change some hidden GNOME settings
    gnomeExtensions.appindicator # Adds appindicators and tray to top bar/dash to panel
    gnomeExtensions.blur-my-shell # Adds a blur look to different parts of the GNOME Shell
    gnomeExtensions.dash-to-panel # Basically Windows-like UX for gnome
    gnomeExtensions.gamemode # Shows Feral GameMode status through notifications and tray
    gnomeExtensions.rounded-window-corners # Makes every window have rounded corners
    gnomeExtensions.user-themes # Custom shell themes
    gnomeExtensions.window-is-ready-remover # Removes annoying GNOME notification
    tela-icon-theme # Nice looking icon theme
    zsh-fast-syntax-highlighting # Syntax highlighting for zsh

    # Desktop software
    ark # KDE archive manager
    discord # IM for pedophiles
    gnome.gnome-terminal # GNOME terminal emulator that's a bit more advanced than GNOME Console
    google-chrome # Proprietary web browser from Google
    onlyoffice-bin # Office suite highly compatible with MS Office formats
    pavucontrol # Best software for managing basic pipewire/pulseaudio settings
    qbittorrent # QT BitTorrent client
    tdesktop # IM for drug dealers
    virt-manager # Desktop user interface for managing virtual machines through libvirt\
    quasselClient # IRC client

    # Media
    ffmpeg
    gnome.eog # Best GTK photo viewer yea
    krita # Open source painting program. You can use it for photography too if you know what you're doing
    lollypop # Best GTK music player yEAAAAH
    mpv # Media player
    nicotine-plus # GTK client for SoulSeek network
    obs-studio # FOSS software for streaming and recording
    yt-dlp # Download manager for video and audio from YouTube and over 1,000 other video hosting websites

    # Gaming
    polymc # Alternative launcher for Minecraft

    # Cryptocurrencies
    electrum # Bitcoin wallet
    electrum-ltc # Litecoin wallet
    ledger-live-desktop # Software for Ledger hardware wallets
    mypkgs.feather-wallet # Monero wallet

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
    config.boot.kernelPackages.cpupower # Manage cpu governor and few other cool things
    dmidecode
    glxinfo # Check if your mesa broke again or "benchmark" your """"gpu"""" with glxgears
    gparted
    htop # TUI task manager
    libva-utils # Check if VAAPI broke again
    lm_sensors
    neofetch # Command-line system information tool
    pciutils
    psmisc # killall
    radeontop # View your AMD GPU utilization
    spectre-meltdown-checker # Check if mitigations=off worked in style
    usbutils # why, why isnt my pendrive working????? i have hardened profile btw

    # Development
    clang_14
    gitFull # Distributed version control
    gnupg # To encrypt DMs on WHM
    go
    llvm_14
    sublime4 # Sophisticated text editor for code, markup and prose.

    # Networking
    bind # nslookup/dig
    nload
    nmap # port scanning
    tailscale # Zero config VPN
    wireshark

    # Misc
    droidcam # Use your phone as a webcam
  ];

  fonts = {
    fonts = with pkgs; [
      cascadia-code # S-tier font for terminal
      mypkgs.apple-emoji-linux # Apple Color emojis
      noto-fonts
      noto-fonts-cjk
    ];
    fontconfig.defaultFonts.emoji = ["Apple Color Emoji"];
  };

  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  programs = {
    gamemode.enable = true;
    adb.enable = true;
  };

  # Anime4K
  environment.etc."mpv/input.conf".text = ''
    CTRL+1 no-osd change-list glsl-shaders set "${mypkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A (Fast)"
    CTRL+2 no-osd change-list glsl-shaders set "${mypkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B (Fast)"
    CTRL+3 no-osd change-list glsl-shaders set "${mypkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C (Fast)"
    CTRL+4 no-osd change-list glsl-shaders set "${mypkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_S.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A+A (Fast)"
    CTRL+5 no-osd change-list glsl-shaders set "${mypkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_S.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B+B (Fast)"
    CTRL+6 no-osd change-list glsl-shaders set "${mypkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_S.glsl:${mypkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C+A (Fast)"
    CTRL+0 no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"
  '';

  # Ledger udev rules
  hardware.ledger.enable = true;

  # Logitech udev rules and software
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  # Overlays
  nixpkgs.overlays = [
    # Dark mode in Google Chrome including websites
    (self: super: {
      google-chrome = super.google-chrome.override {
        commandLineArgs = "--enable-features=WebUIDarkMode --force-dark-mode";
      };
    })
    # Install OpenAsar for Discord
    (self: super: {
      discord = super.discord.override {
        withOpenASAR = true;
      };
    })
    # Install scripts for mpv
    (self: super: {
      mpv = super.wrapMpv self.mpv-unwrapped {
        scripts = [self.mpvScripts.youtube-quality self.mpvScripts.mpris];
      };
    })
  ];

  # Chromium config
  programs.chromium = {
    enable = true;
    extraOpts = {
      "DefaultJavaScriptJitSetting" = 2;
      "HistoryClustersVisible" = false;
      "SavingBrowserHistoryDisabled" = true;
    };
    extensions = [
      # Manifest version in parenthesis
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite (3)
      "fihnjjcciajhdojfnbdddfaoknhalnja" # I don't care about cookies (3)
      "gebbhagfogifgggkldgodflihgfeippi" # Return YouTube dislike (3)
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden (3)
      "omkfmpieigblcllmkgbflkikinpkodlk" # enhanced-h264ify (2)
      "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs (2)
      "mafpmfcccpbjnhfhjnllmmalhifmlcie" # TOR Snowflake (2)
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube (2)
    ];
  };

  # Hardened profile fixes/overrides/additions
  security = {
    lockKernelModules = false;
    unprivilegedUsernsClone = true;
  };
}
