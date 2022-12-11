{ pkgs
, stdenv
, fetchzip
, fetchurl
, makeDesktopItem
, autoPatchelfHook
,
}:
stdenv.mkDerivation rec {
  name = "feather-wallet";
  version = "2.1.0";

  src = fetchzip {
    url = "https://featherwallet.org/files/releases/linux/feather-${version}-linux.zip";
    sha256 = "sha256-BYi7R+FqgG8li3W6yuKENiqylkhMvZM4APpL+8nUrzI=";
  };

  iconFile = fetchurl {
    url = "https://featherwallet.org/img/Feather-icon.png";
    sha256 = "sha256-1FnTy2P8Ukpv1MOmgY/OHO4tbioNyf+F3mGkQTOiqyI=";
  };

  desktopItem = makeDesktopItem {
    name = name;
    desktopName = "Feather Wallet";
    comment = "A free Monero desktop wallet";
    icon = name;
    exec = "${name} %F";
    startupNotify = true;
    startupWMClass = name;
    categories = [ "Utility" ];
    keywords = [ "feather" "wallet" "monero" ];
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = with pkgs; [
    eudev
    glib
    libxkbcommon
    xorg.libX11
    xorg.libxcb
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil
    xorg.xcbutilwm
    zlib
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    install -Dm755 ./feather-${version} $out/bin/${name}
    install -Dm644 ${desktopItem}/share/applications/${name}.desktop $out/share/applications/${name}.desktop
    install -Dm644 ${iconFile} $out/share/pixmaps/${name}.png
  '';
}
