{ config, ... }: {
  services.minidlna = {
    enable = true;
    openFirewall = true;
    settings = {
      inotify = "yes";
      media_dir = [ "V,/media/hdd/Torrent/DL" ];
      friendly_name = config.networking.hostName;
    };
  };

  services.darkhttpd = {
    enable = true;
    port = 9090;
    address = "all";
    rootDir = "/media/hdd/Torrent";
  };

  networking.firewall.allowedTCPPorts = [ config.services.darkhttpd.port ];
}
