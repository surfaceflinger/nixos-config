{ ... }: {
  imports = [ ./networking-base.nix ];

  networking = {
    useDHCP = false;
    networkmanager.enable = true;
  };

  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}
