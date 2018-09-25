{ removeReferencesTo, lib, fetchFromGitHub, buildGoPackage, stdenv, fetchgit, go, git, ... }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "ksm-throttler-${version}";

  # https://github.com/NixOS/nixpkgs/issues/25959
  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    owner = "kata-containers";
    repo = "ksm-throttler";
    rev = "${version}";
    sha256 = "0dj6b7ay0kpja4ivs16a57dh44ywfv0lvm01bn9z5v9as39sb74h";
  };

  nativeBuildInputs = [ removeReferencesTo go git ];

  preConfigure = ''
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/github.com/kata-containers"
    mv "$sourceRoot" "go/src/github.com/kata-containers/ksm-throttler"
    export GOPATH=$NIX_BUILD_TOP/go
  '';

  preBuild = ''
    cd go/src/github.com/kata-containers/ksm-throttler
    patchShebangs .
  '';

  makeFlags = [
    "PREFIX=$(out)"
  ];

  preFixup = ''
    find $out -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    description = "todo";
    homepage = https://github.com/kata-containers/ksm-throttler;
    license = lib.licenses.asl20; # TODO
    maintainers = with lib.maintainers; [ colemickens ]; # TODO
    platforms = lib.platforms.unix; # TODO linux only
  };
}

