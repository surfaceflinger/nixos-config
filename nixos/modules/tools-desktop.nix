{ pkgs, ... }: {
  imports = [ ./tools-standard.nix ];

  environment.systemPackages = with pkgs; [
    # Desktop software
    filen-desktop
    qbittorrent
    quasselClient
    tdesktop
    xfce.mousepad
    textpieces

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
