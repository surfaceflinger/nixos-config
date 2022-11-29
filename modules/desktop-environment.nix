{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
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
      yelp
    ]);

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

    # Desktop software
    gnome.gnome-terminal # GNOME terminal emulator that's a bit more advanced than GNOME Console

    # Media
    ffmpeg

    # System utilities
    glxinfo # Check if your mesa broke again or "benchmark" your """"gpu"""" with glxgears
    libva-utils # Check if VAAPI broke again
    radeontop # View your AMD GPU utilization

    # Development
    sublime4 # Sophisticated text editor for code, markup and prose.

    # Misc
    scrcpy
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
  security.unprivilegedUsernsClone = true;
}
