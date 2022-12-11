{ ... }: {
  imports = [
    ../modules/base.nix
    ../modules/chromium.nix
    ../modules/crypto-wallets.nix
    ../modules/desktop-environment.nix
    ../modules/hardening.nix
    ../modules/mitigations-off.nix
    ../modules/networking-base.nix
    ../modules/networking-desktop.nix
    ../modules/openssh.nix
    ../modules/printing.nix
    ../modules/sound.nix
    ../modules/tools-desktop.nix
    ../modules/tools-standard.nix
  ];
}
