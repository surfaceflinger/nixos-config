{config, ...}: {
  services.freshrss = {
    enable = true;
    virtualHost = "freshrss";
    baseUrl = "http://${config.networking.hostName}:8000";
    passwordFile = "/var/lib/freshrss/password";
  };

  services.nginx.virtualHosts."freshrss".listen = [
    {
      addr = "0.0.0.0";
      port = 8000;
    }
  ];
}
