{ buildGoPackage, fetchurl, lib }:

let
version = "1.12.0";
in
buildGoPackage {
  name = "cri-tools-${version}";
  src = builtins.fetchTarball {
    url = "https://github.com/kubernetes-sigs/cri-tools/archive/v${version}.tar.gz";
    sha256 = "1mz4d6vvwcgmd830ivlxjcxmznb5kdaqlvakfp18xwr1rzakik94";
  };

  goPackagePath = "github.com/kubernetes-sigs/cri-tools";
  subPackages = [ "cmd/crictl" "cmd/critest" ];

  meta = {
    license = lib.licenses.asl20;
  };
}

