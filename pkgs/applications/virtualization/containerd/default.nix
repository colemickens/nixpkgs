{ stdenv, lib, fetchFromGitHub, removeReferencesTo
, go, btrfs-progs }:

with lib;

stdenv.mkDerivation rec {
  name = "containerd-${version}";
  version = "1.2.0-92d58bf8f01d4196b6cca09987b03f036be89d96";

  src = fetchFromGitHub {
    owner = "containerd";
    repo = "containerd";
    rev = "92d58bf8f01d4196b6cca09987b03f036be89d96";
    sha256 = "0g9nr3bz3nqjkc0gz234b15fclgz6j4mvplhrcwv9n4z1pd23n71";
  };

  hardeningDisable = [ "fortify" ];

  buildInputs = [ removeReferencesTo go btrfs-progs ];
  buildFlags = "VERSION=v${version}";

  BUILDTAGS = []
    ++ optional (btrfs-progs == null) "no_btrfs";

  preConfigure = ''
    # Extract the source
    cd "$NIX_BUILD_TOP"
    mkdir -p "go/src/github.com/containerd"
    mv "$sourceRoot" "go/src/github.com/containerd/containerd"
    export GOPATH=$NIX_BUILD_TOP/go:$GOPATH
'';

  preBuild = ''
    cd go/src/github.com/containerd/containerd
    patchShebangs .
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/* $out/bin
  '';

  preFixup = ''
    find $out -type f -exec remove-references-to -t ${go} '{}' +
  '';

  meta = {
    homepage = https://containerd.io/;
    description = "A daemon to control runC";
    license = licenses.asl20;
    maintainers = with maintainers; [ offline vdemeester ];
    platforms = platforms.linux;
  };
}
