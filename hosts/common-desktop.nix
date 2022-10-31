{ config
, pkgs
, ...
}: {
  # kernel args
  boot.kernelParams = [ "noibrs" "noibpb" "nopti" "nospectre_v2" "nospectre_v1" "l1tf=off" "nospec_store_bypass_disable" "no_stf_barrier" "mds=off" "tsx=on" "tsx_async_abort=off" "mitigations=off" ];

  # Networking
  networking.networkmanager.enable = true;
  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };

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
      gnome-console
      gnome-photos
      gnome-text-editor
      gnome-tour
      gnome-user-docs
    ])
    ++ (with pkgs.gnome; [
      baobab
      cheese
      epiphany
      evince
      geary
      gedit
      gnome-characters
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-music
      gnome-software
      gnome-system-monitor
      simple-scan
      totem
      yelp
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

  # Printing
  services.printing = {
    enable = true;
    webInterface = false;
    stateless = true;
  };

  # Users
  users.users.nat.extraGroups = [ "libvirtd" "networkmanager" "adbusers" ];

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

    # Desktop software
    discord # IM for pedophiles
    gnome.gnome-terminal # GNOME terminal emulator that's a bit more advanced than GNOME Console
    google-chrome # Proprietary web browser from Google
    onlyoffice-bin # Office suite highly compatible with MS Office formats
    pavucontrol # Best software for managing basic pipewire/pulseaudio settings
    qbittorrent # QT BitTorrent client
    quasselClient # IRC client
    tdesktop # IM for drug dealers
    virt-manager # Desktop user interface for managing virtual machines through libvirt\

    # Media
    ffmpeg
    krita # Open source painting program. You can use it for photography too if you know what you're doing
    lollypop # Best GTK music player yEAAAAH
    mpv # Media player
    nicotine-plus # GTK client for SoulSeek network
    obs-studio # FOSS software for streaming and recording
    yt-dlp # Download manager for video and audio from YouTube and over 1,000 other video hosting websites

    # Gaming
    prismlauncher # Alternative launcher for Minecraft

    # Cryptocurrencies
    electrum # Bitcoin wallet
    electrum-ltc # Litecoin wallet
    feather-wallet # Monero wallet
    ledger-live-desktop # Software for Ledger hardware wallets

    # System utilities
    glxinfo # Check if your mesa broke again or "benchmark" your """"gpu"""" with glxgears
    libva-utils # Check if VAAPI broke again
    radeontop # View your AMD GPU utilization
    wireshark

    # Development
    clang_14
    gitFull # Distributed version control
    gnupg # To encrypt DMs on WHM
    go
    llvm_14
    sublime4 # Sophisticated text editor for code, markup and prose.

    # Misc
    droidcam # Use your phone as a webcam
    scrcpy
    spice-gtk # Needed for simple usb forwarding in virt-manager
  ];

  fonts = {
    fonts = with pkgs; [
      apple-emoji-linux # Apple Color emojis
      cascadia-code # S-tier font for terminal
      noto-fonts
      noto-fonts-cjk
    ];
    fontconfig.defaultFonts.emoji = [ "Apple Color Emoji" ];
  };

  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  programs = {
    gamemode.enable = true;
    adb.enable = true;
  };

  # Anime4K
  environment.etc."mpv/input.conf".text = with pkgs; ''
    CTRL+1 no-osd change-list glsl-shaders set "${anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A (Fast)"
    CTRL+2 no-osd change-list glsl-shaders set "${anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_M.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B (Fast)"
    CTRL+3 no-osd change-list glsl-shaders set "${anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C (Fast)"
    CTRL+4 no-osd change-list glsl-shaders set "${anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/usr/share/shaders/Anime4K_Restore_CNN_S.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode A+A (Fast)"
    CTRL+5 no-osd change-list glsl-shaders set "${anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_M.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_S.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode B+B (Fast)"
    CTRL+6 no-osd change-list glsl-shaders set "${anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_M.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${anime4k}/usr/share/shaders/Anime4K_Restore_CNN_S.glsl:${anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_S.glsl"; show-text "Anime4K: Mode C+A (Fast)"
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
    (self: super: {
      # Packages
      anime4k = super.callPackage ../packages/anime4k { };
      apple-emoji-linux = super.callPackage ../packages/apple-emoji-linux { };
      feather-wallet = super.callPackage ../packages/feather-wallet { };
      # Overrides
      discord = super.discord.override { withOpenASAR = true; };
      google-chrome = super.google-chrome.override { commandLineArgs = "--enable-features=WebUIDarkMode --force-dark-mode"; };
      mpv = super.wrapMpv self.mpv-unwrapped { scripts = [ self.mpvScripts.youtube-quality self.mpvScripts.mpris ]; };
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
      "lckanjgmijmafbedllaakclkaicjfmnk" # ClearURLs (2)
      "mafpmfcccpbjnhfhjnllmmalhifmlcie" # TOR Snowflake (2)
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock for YouTube (2)
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden (3)
      "omkfmpieigblcllmkgbflkikinpkodlk" # enhanced-h264ify (2)
    ];
  };
}
