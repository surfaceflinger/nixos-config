{ pkgs
, stdenv
, fetchzip
,
}:
stdenv.mkDerivation rec {
  pname = "Anime4k";
  version = "4.0.1";

  src = fetchzip {
    url = "https://github.com/bloc97/Anime4K/releases/download/v4.0.1/Anime4K_v4.0.zip";
    sha256 = "sha256-9B6U+KEVlhUIIOrDauIN3aVUjZ/gQHjFArS4uf/BpaM=";
    stripRoot = false;
  };

  installPhase = ''
    find . -type f -iname '*.glsl' -exec install -Dm 644 {} -t $out/usr/share/shaders/ \;
  '';
}
