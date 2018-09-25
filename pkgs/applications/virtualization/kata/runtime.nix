{ removeReferencesTo, lib, fetchFromGitHub, buildGoPackage, stdenv, fetchgit, go, git, ... }:

stdenv.mkDerivation rec {
  version = "a73fd0702a65b88b0358dba9723f275876bbe3d6";
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
    rev = "a73fd0702a65b88b0358dba9723f275876bbe3d6";
    sha256 = "1rpmaqghih73yhphm6yd3cgjqcs4lkp0lp4vfr7g66d0b6zpfak8";
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

