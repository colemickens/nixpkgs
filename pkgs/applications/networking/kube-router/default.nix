{ stdenv, buildGoPackage, fetchFromGitHub, fetchgx }:

buildGoPackage rec {
  name = "kube-router-${version}";
  version = "0.2.1";
  rev = "v${version}";

  goPackagePath = "github.com/cloudnativelabs/kube-router";

  extraSrcPaths = [
    (fetchgx {
      inherit name src;
      sha256 = "0grdgnr67r3qh0ppc3flrhcw8zlvx10mxypd8q2mhkil9w4dpcna";
    })
  ];

  src = fetchFromGitHub {
    owner = "cloudnativelabs";
    repo = "kube-router";
    inherit rev;
    sha256 = "18skmchdqd54wfqhibscqvc360l5ig6vmxd73ivf3bcpj3zvgqqq";
  };

  meta = with stdenv.lib; {
    description = "A global, versioned, peer-to-peer filesystem";
    homepage = https://ipfs.io/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
