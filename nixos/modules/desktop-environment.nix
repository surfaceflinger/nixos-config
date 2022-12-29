{pkgs, ...}: {
  services.xserver = {
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
  };

  # Debloat
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-connections
      gnome-console
      gnome-photos
      gnome-text-editor
      gnome-tour
      gnome-user-docs
      orca
    ])
    ++ (with pkgs.gnome; [
      baobab
      cheese
      epiphany
      evince
      geary
      gedit
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-music
      gnome-shell-extensions
      gnome-software
      gnome-system-monitor
      gnome-themes-extra
      gnome-weather
      simple-scan
      totem
      yelp
    ]);

  # Other software
  environment.systemPackages = with pkgs; [
    # GNOME
    gnomeExtensions.appindicator # Adds appindicators and tray to top bar/dash to panel
    gnomeExtensions.gamemode # Shows Feral GameMode status through notifications and tray
    gnomeExtensions.user-themes
    gnomeExtensions.window-is-ready-remover # Removes annoying GNOME notification
    gnome.gnome-session

    # Theming
    adw-gtk3

    # System utilities
    glxinfo
    libva-utils
  ];

  programs.gnome-terminal.enable = true;

  fonts = {
    fonts = with pkgs; [
      apple-emoji-linux # Apple Color emojis
      cascadia-code # S-tier font for terminal
      noto-fonts
      noto-fonts-cjk
    ];
    fontconfig.defaultFonts.emoji = ["Apple Color Emoji"];
  };

  programs.gamemode.enable = true;
  security.unprivilegedUsernsClone = true;
  services.flatpak.enable = true;
  services.power-profiles-daemon.enable = false;
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];
}
