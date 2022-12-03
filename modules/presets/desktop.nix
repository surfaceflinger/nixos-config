{ ... }: {
  imports = [
    ../base.nix
    ../chromium.nix
    ../crypto-wallets.nix
    ../desktop-environment.nix
    ../hardening.nix
    ../mitigations-off.nix
    ../networking-base.nix
    ../networking-desktop.nix
    ../openssh.nix
    ../overlay.nix
    ../printing.nix
    ../sound.nix
    ../tools-desktop.nix
    ../tools-standard.nix
  ];
}
