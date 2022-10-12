{
  pkgs,
  pythonPkgs ? pkgs.python310Packages,
}: let
  inherit pkgs;
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
        rev = "36ec87c83d1f50ab0b0f4a471e9d3b8fd655ab90";
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
