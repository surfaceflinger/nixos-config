{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  mypkgs = import ../packages {inherit pkgs;};
in {
  # kernel args
  boot.kernelParams = ["amd_iommu=on" "intel_iommu=on"];

  # zram swap
  zramSwap.enable = true;

  time.timeZone = mkDefault "Europe/Warsaw";

  # Locale and keymap
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  console.keyMap = mkDefault "pl";

  # Users
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["root"];
          groups = ["wheel"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  programs.zsh.enable = true;

  users.users.nat = {
    isNormalUser = true;
    extraGroups = ["wheel"];
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

  nixpkgs.config.allowUnfree = true;
  programs.gnupg.agent.enable = true;

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

  # Flakes support
  nix.extraOptions = "experimental-features = nix-command flakes";

  # GC
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Limit generations
  boot.loader = {
    systemd-boot.configurationLimit = mkDefault 5;
    grub.configurationLimit = mkDefault 5;
  };

  # Auto upgrade and optimise
  system.autoUpgrade = {
    enable = true;
    flake = "github:surfaceflinger/nixos-config";
  };
  nix.settings.auto-optimise-store = true;

  # stateVersion
  system.stateVersion = "22.11";
}
