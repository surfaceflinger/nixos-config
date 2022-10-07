{
  config,
  pkgs,
  ...
}: {
  # zram swap
  zramSwap.enable = true;

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

  time.timeZone = "Europe/Warsaw";

  services.tailscale.enable = true;

  # Locale and keymap
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "pl";

  # Desktop environment
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

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

  # Fix cursors in QT software (not even sure if it helps)
  environment.variables = {QT_QPA_PLATFORM = "xcb";};

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
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["root"];
          groups = ["wheel"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  programs.zsh.enable = true;

  users.users.nat = {
    isNormalUser = true;
    extraGroups = ["wheel" "libvirtd" "networkmanager"];
    shell = pkgs.zsh;
  };

  # Other software
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Wrappers
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
    (pkgs.writeScriptBin "youtube-dl" ''exec yt-dlp "$@"'')

    # Rice / UX
    gnomeExtensions.blur-my-shell # Adds a blur look to different parts of the GNOME Shell
    gnomeExtensions.dash-to-panel # Basically Windows-like UX for gnome
    gnomeExtensions.user-themes # Custom shell themes
    gnomeExtensions.rounded-window-corners # Makes every window have rounded corners
    gnomeExtensions.window-is-ready-remover # Removes annoying GNOME notification
    gnomeExtensions.gamemode # Shows Feral GameMode status through notifications and tray
    gnomeExtensions.appindicator # Adds appindicators and tray to top bar/dash to panel
    gnome.gnome-tweaks # App to change some hidden GNOME settings
    adw-gtk3 # libadwaita look for gtk3 software
    tela-icon-theme # Nice looking icon theme
    cascadia-code # S-tier font for terminal
    zsh-fast-syntax-highlighting # Syntax highlighting for zsh

    # Desktop software
    gnome.gnome-terminal # GNOME terminal emulator that's a bit more advanced than GNOME Console
    google-chrome # Proprietary web browser from Google
    tdesktop # IM for drug dealers
    discord # IM for pedophiles
    virt-manager # Desktop user interface for managing virtual machines through libvirt\
    pavucontrol # Best software for managing basic pipewire/pulseaudio settings
    qbittorrent # QT BitTorrent client
    ark # KDE archive manager
    onlyoffice-bin # Office suite highly compatible with MS Office formats

    # Media
    gnome.eog # Best GTK photo viewer yea
    lollypop # Best GTK music player yEAAAAH
    nicotine-plus # GTK client for SoulSeek network
    krita # Open source painting program. You can use it for photography too if you know what you're doing
    obs-studio # FOSS software for streaming and recording
    mpv # Media player
    yt-dlp # Download manager for video and audio from YouTube and over 1,000 other video hosting websites

    # Gaming
    polymc # Alternative launcher for Minecraft

    # Cryptocurrencies
    electrum # Bitcoin wallet
    electrum-ltc # Litecoin wallet
    monero-gui # Monero wallet
    ledger-live-desktop # Software for Ledger hardware wallets

    # CLI/TUI tools
    nano # vim is useless
    wget # Retrieving files using HTTP, HTTPS, FTP and FTPS
    tree # List contents of directories in a tree-like format
    alejandra # nix beautifier (in Rust 🚀)

    # System utilities
    glxinfo # Check if your mesa broke again or "benchmark" your """"gpu"""" with glxgears
    libva-utils # Check if VAAPI broke again
    usbutils # why, why isnt my pendrive working????? i have hardened profile btw
    config.boot.kernelPackages.cpupower # Manage cpu governor and few other cool things
    spectre-meltdown-checker # Check if mitigations=off worked in style
    neofetch # Command-line system information tool
    htop # TUI task manager
    radeontop # View your AMD GPU utilization

    # Development
    sublime4 # Sophisticated text editor for code, markup and prose.
    gitFull # Distributed version control
    gnupg # To encrypt DMs on WHM

    # Networking
    tailscale # Zero config VPN
  ];

  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
  programs.gamemode.enable = true;
  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.gnupg.agent.enable = true;

  # Ledger udev rules
  hardware.ledger.enable = true;

  # Logitech udev rules and software
  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true;

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

  # Hardened profile fixes/overrides/additions
  security = {
    lockKernelModules = false;
    chromiumSuidSandbox.enable = true;
    unprivilegedUsernsClone = true;
    allowSimultaneousMultithreading = true;
    pam.loginLimits = [
      {
        domain = "*";
        item = "core";
        type = "hard";
        value = "0";
      }
    ];
  };
  systemd.coredump.enable = false;
  environment.memoryAllocator.provider = "libc";

  # Flakes support
  nix = {
    extraOptions = "experimental-features = nix-command flakes";
  };

  # GC
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Limit generations
  boot.loader = {
    systemd-boot.configurationLimit = 5;
    grub.configurationLimit = 5;
  };

  # stateVersion
  system.stateVersion = "22.11";
}
