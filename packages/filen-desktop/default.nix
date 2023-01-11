{ fetchurl, appimageTools, makeDesktopItem }:

let
  pname = "filen-desktop";
  version = "2.0.14";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "http://web.archive.org/web/20230111182152/https://cdn.filen.io/desktop/release/filen_x86_64.AppImage";
    sha256 = "UA39m5jYQqCo47et/woStjBGq3hQ8fVav2qZKI391S4=";
  };

  contents = appimageTools.extractType2 {
    inherit pname version src;
  };

  desktopItem = makeDesktopItem {
    name = "${pname}";
    desktopName = "Filen Sync";
    comment = "Desktop client for filen.io";
    exec = "${pname} %U";
    icon = "filen-desktop-client";
  };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    mkdir -p $out/share
    cp -rt $out/share ${desktopItem}/share/applications ${contents}/usr/share/icons
    chmod -R +w $out/share
  '';
}
