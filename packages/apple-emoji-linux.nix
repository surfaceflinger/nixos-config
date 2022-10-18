{ pkgs
, stdenv
, fetchurl
,
}:
stdenv.mkDerivation rec {
  name = "apple-emoji-linux";
  version = "ios-15.4";

  src = fetchurl {
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/${version}/AppleColorEmoji.ttf";
    sha256 = "sha256-CDmtLCzlytCZyMBDoMrdvs3ScHkMipuiXoNfc6bfimw=";
  };

  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;

  installPhase = ''
    install -Dm444 ${src} $out/share/fonts/truetype/${name}.ttf
  '';
}
