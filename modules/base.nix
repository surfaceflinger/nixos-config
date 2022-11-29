{ config
, pkgs
, lib
, ...
}: {
  # fstrim
  services.fstrim = {
    enable = true;
    interval = "daily";
  };

  # zram swap
  zramSwap.enable = true;

  # tmpfs
  boot.tmpOnTmpfs = true;

  # Regional
  i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";
  console.keyMap = lib.mkDefault "pl";
  time.timeZone = lib.mkDefault "Europe/Warsaw";

  # doas
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "root" ];
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  # Other software
  environment.systemPackages = with pkgs; [
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
    gnupg
  ];
  programs = {
    gnupg.agent.enable = true;
    zsh.enable = true;
  };
  services.journald.extraConfig = "Storage=volatile";

  # Limit amount of generations
  boot.loader = {
    systemd-boot.configurationLimit = lib.mkDefault 5;
    grub.configurationLimit = lib.mkDefault 5;
  };

  # Nix
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings.auto-optimise-store = true;
    extraOptions = "experimental-features = nix-command flakes";
  };

  system = {
    autoUpgrade = {
      enable = lib.mkDefault true;
      flake = "github:surfaceflinger/nixos-config";
    };
    stateVersion = "22.11";
  };

  nixpkgs.config.allowUnfree = true;
}