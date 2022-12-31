{pkgs, ...}: {
  imports = [./tools-standard.nix];

  environment.systemPackages = with pkgs; [
    # Desktop software
    qbittorrent
    quasselClient
    tdesktop
    xfce.mousepad
    textpieces
    apostrophe

    # Media
    krita
    lollypop
    mpv
    yt-dlp
    newsflash
    curtail

    # Gaming
    gamescope
    prismlauncher
  ];
}
