{pkgs}: {
  feather-wallet = import ./feather-wallet.nix {
    inherit (pkgs) pkgs stdenv fetchzip fetchurl makeDesktopItem autoPatchelfHook;
  };
  apple-emoji-linux = import ./apple-emoji-linux.nix {
    inherit (pkgs) pkgs stdenv fetchurl;
  };
}
