{
  nixpkgs ? import <nixpkgs> {},
  pythonPkgs ? nixpkgs.pkgs.python310Packages,
}: let
  inherit (nixpkgs) pkgs;
  inherit pythonPkgs;

  f = {
    buildPythonPackage,
    python-telegram-bot,
    requests,
  }:
    buildPythonPackage rec {
      pname = "xkomhotshots";
      version = "0.0.1";

      src = builtins.fetchGit {
        url = "https://github.com/surfaceflinger/xkomhotshot.git";
        ref = "master";
      };

      propagatedBuildInputs = [python-telegram-bot requests];

      doCheck = false;

      # Meta information for the package
      meta = {
        description = ''
          Receive notifications on Telegram about new promotions on x-kom.pl
        '';
      };
    };

  drv = pythonPkgs.callPackage f {};
in
  if pkgs.lib.inNixShell
  then drv.env
  else drv
