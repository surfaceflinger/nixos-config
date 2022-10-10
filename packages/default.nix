{pkgs}: {
  feather-wallet = import ./feather-wallet.nix {
    inherit (pkgs) pkgs stdenv fetchzip fetchurl makeDesktopItem autoPatchelfHook;
  };
}
