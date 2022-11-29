{ ... }: {
  imports = [
    ../base.nix
    ../hardening.nix
    ../networking-base.nix
    ../openssh.nix
    ../overlay.nix
    ../tools-standard.nix
  ];
}
