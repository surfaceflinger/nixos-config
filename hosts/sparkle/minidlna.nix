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
}
