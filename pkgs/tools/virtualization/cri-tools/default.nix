{ buildGoPackage, fetchurl, lib }:

let
version = "98eea54";
in
buildGoPackage
  {
    name = "cri-tools-${version}";
    src = fetchurl
      { url = "https://github.com/kubernetes-sigs/cri-tools/archive/98eea54af789ae13edce79cba101fb9ac8e7b241.tar.gz";
        sha256 = "13dcrwnqqspvh62qbxd2s5m1sf7am58820ahji7sz2bsm72jzwzp";
      };

    goPackagePath = "github.com/kubernetes-sigs/cri-tools";
    subPackages = [ "cmd/crictl" "cmd/critest" ];

    meta = {
      license = lib.licenses.asl20;
    };

#    goDeps = ./deps.nix;
  }

