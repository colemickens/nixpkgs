{ removeReferencesTo, lib, fetchFromGitHub, buildGoPackage, stdenv, fetchgit, go, git, ... }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "kata-shim-${version}";

  # https://github.com/NixOS/nixpkgs/issues/25959
  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    owner = "kata-containers";
    repo = "shim";
    rev = "${version}";
    sha256 = "04yhkjyqlxwr8kyv3n7vgfcqip1h1havgf4w1dx1ccb95g28dk5z";
  };

  nativeBuildInputs = [ removeReferencesTo go git ];

  preConfigure = ''
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/github.com/kata-containers"
    mv "$sourceRoot" "go/src/github.com/kata-containers/shim"
    export GOPATH=$NIX_BUILD_TOP/go:$GOPATH
  '';

  preBuild = ''
    cd go/src/github.com/kata-containers/shim
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
    homepage = https://github.com/kata-containers/shim;
    license = lib.licenses.asl20; # TODO
    maintainers = with lib.maintainers; [ colemickens ]; # TODO
    platforms = lib.platforms.unix; # TODO linux only
  };
}

