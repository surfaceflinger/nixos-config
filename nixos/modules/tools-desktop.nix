{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Desktop software
    qbittorrent
    quasselClient
    tdesktop
    xfce.mousepad
    gnome-feeds

    # Media
    krita
    lollypop
    mpv
    nicotine-plus
    obs-studio
    yt-dlp

    # Gaming
    prismlauncher-qt5
  ];
}
