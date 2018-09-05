{ removeReferencesTo, lib, fetchFromGitHub, buildGoPackage, stdenv, fetchgit, go, git, ... }:

stdenv.mkDerivation rec {
  version = "1.2.1";
  name = "kata-runtime-${version}";

  # https://github.com/NixOS/nixpkgs/issues/25959
  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
#   owner = "kata-containers";
#   repo = "runtime";    
#   rev = "${version}";
#   sha256 = "06rb3w2qm5ya6fnqlin0g7gn897ky4j0b78qjb71sdamygaz58bg";
    owner = "hyperhq";
    repo = "kata-runtime";
    rev = "b811a7338ac942eb6f98475656081d68c26f3074";
    sha256 = "151sgcp9yrdrak3p8cvhyvb202bg9klfx8zqp3q1sjl7w5fp94ia";
  };

  nativeBuildInputs = [ removeReferencesTo go git ];

  preConfigure = ''
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/github.com/kata-containers"
    mv "$sourceRoot" "go/src/github.com/kata-containers/runtime"
    export GOPATH=$NIX_BUILD_TOP/go:$GOPATH
  '';

  preBuild = ''
    cd go/src/github.com/kata-containers/runtime
    patchShebangs .
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX=/"
  ];

  preFixup = ''
    find $out -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    description = "todo";
    homepage = https://github.com/kata-containers/runtime;
    license = lib.licenses.asl20; # TODO
    maintainers = with lib.maintainers; [ colemickens ]; # TODO
    platforms = lib.platforms.unix; # TODO linux only
  };
}

