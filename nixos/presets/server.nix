{...}: {
  imports = [
    ../modules/base.nix
    ../modules/hardening.nix
    ../modules/networking-base.nix
    ../modules/openssh.nix
    ../modules/tools-standard.nix
  ];
}
