{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  mypkgs = import ../packages {inherit pkgs;};
in {
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

  # stateVersion
  system.stateVersion = "22.11";
}
