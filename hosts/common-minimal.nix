{ config
, pkgs
, lib
, ...
}:
with lib; {
  # kernel args
  boot.kernelParams = [ "amd_iommu=on" "intel_iommu=on" ];

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
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console.keyMap = mkDefault "pl";
  time.timeZone = mkDefault "Europe/Warsaw";

  # Users
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

  programs.zsh.enable = true;

  users.users.nat = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBeWbH2L99MoMuT2a1nzmpI86VBht/io2TBraa2Pe98F nat@sparkle"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANRmkBgx14Oa1CKUQfS76V0ixEJzKhHlM8XF7qqiapa nat@apricot"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEqJ6aKTV33D1iZcuEw86lQ6QxmcfqIEcpBs4Da7GjI2 hanoip"
    ];
  };

  # Other software
  environment.systemPackages = with pkgs; [
    # Wrappers
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
  ];

  programs.gnupg.agent.enable = true;
  services.journald.extraConfig = "Storage=volatile";

  # Hardened profile fixes/overrides/additions
  security = {
    allowSimultaneousMultithreading = true;
    pam.loginLimits = [
      {
        domain = "*";
        item = "core";
        type = "hard";
        value = "0";
      }
    ];
  };
  systemd.coredump.enable = false;
  environment.memoryAllocator.provider = "libc";

  # Limit generations
  boot.loader = {
    systemd-boot.configurationLimit = mkDefault 5;
    grub.configurationLimit = mkDefault 5;
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
      enable = mkDefault true;
      flake = "github:surfaceflinger/nixos-config";
    };
    stateVersion = "22.11";
  };

  nixpkgs.config.allowUnfree = true;
}
