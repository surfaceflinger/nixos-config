{ pkgs ? (import ../nixpkgs.nix) { } }: {
  anime4k = pkgs.callPackage ./anime4k { };
  apple-emoji-linux = pkgs.callPackage ./apple-emoji-linux { };
  feather-wallet = pkgs.qt6.callPackage ./feather-wallet { };
  filen-desktop = pkgs.callPackage ./filen-desktop { };
}
