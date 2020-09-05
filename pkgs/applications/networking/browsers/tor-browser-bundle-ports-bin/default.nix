{ lib, tor-browser-bundle-bin, fetchurl }:

let
  version = "10.0";
  lang = "en-us";
in
tor-browser-bundle-bin.overrideDerivation(old: {
  pname = "tor-browser-bundle-ports-bin";

  src = fetchurl {
    url = "mirror://sourceforge/tor-browser-ports/tor-browser-linux-arm64-${version}_${lang}.tar.xz";
    sha256 = "sha256-ZrAxBKYydr47qRlgr91sXllK8Cyvx1UR6YdGMBLS0/w=";
  };

  meta.platforms = [ "aarch64-linux" ];
})

