{pkgs, ...}: {
  imports = [./tools-standard.nix];

  environment.systemPackages = with pkgs; [
    # Desktop software
    qbittorrent
    quasselClient
    tdesktop
    xfce.mousepad
    newsboat

    # Media
    krita
    lollypop
    mpv
    nicotine-plus
    obs-studio
    yt-dlp

    # Gaming
    gamescope
    prismlauncher-qt5
  ];
}
