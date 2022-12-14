{ lib, ... }: {
  imports = [
    ../modules/base.nix
    ../modules/chromium.nix
    ../modules/crypto-wallets.nix
    ../modules/desktop-environment.nix
    ../modules/mitigations-off.nix
    ../modules/networking-desktop.nix
    ../modules/openssh.nix
    ../modules/printing.nix
    ../modules/sound.nix
    ../modules/tools-desktop.nix
  ];

  services.thermald.enable = true;
  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";
}
