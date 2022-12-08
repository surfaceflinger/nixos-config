{ lib, stdenv, fetchurl, openjdk, runtimeShell, unzip, chromium }:

stdenv.mkDerivation rec {
  pname = "burpsuite";
  version = "2022.11.4";

  src = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger-cdn.net/burp/releases/download?product=community&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger-cdn.net/burp/releases/download?product=community&version=${version}&type=Jar"
    ];
    sha256 = "num3FrwBbZw0EO4nSHZnXGRvLyBkjovhvkNGbnUQIT4=";
  };

  dontUnpack = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    echo '#!${runtimeShell}
    eval "$(${unzip}/bin/unzip -p ${src} chromium.properties)"
    mkdir -p "$HOME/.BurpSuite/burpbrowser/$linux64"
    ln -sf "${chromium}/bin/chromium" "$HOME/.BurpSuite/burpbrowser/$linux64/chrome"
    exec ${openjdk}/bin/java --illegal-access=permit -jar ${src} "$@"' > $out/bin/burpsuite
    chmod +x $out/bin/burpsuite

    runHook postInstall
  '';

  preferLocalBuild = true;
}
