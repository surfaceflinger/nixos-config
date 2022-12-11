{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    electrum
    electrum-ltc
    feather-wallet
    #ledger-live-desktop
  ];

  hardware.ledger.enable = true;
}
