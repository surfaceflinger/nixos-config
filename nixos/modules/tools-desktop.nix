{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Desktop software
    qbittorrent
    quasselClient
    tdesktop

    # Media
    krita
    lollypop
    mpv
    nicotine-plus
    obs-studio
    yt-dlp

    # Gaming
    prismlauncher
  ];
}
