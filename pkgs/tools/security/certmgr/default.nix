{ stdenv, buildGoPackage, fetchFromGitHub, fetchpatch }:

buildGoPackage rec {
  version = "1.6.1";
  name = "certmgr-${version}";

  goPackagePath = "github.com/cloudflare/certmgr/";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "certmgr";
    rev = "v${version}";
    sha256 = "1ky2pw1wxrb2fxfygg50h0mid5l023x6xz9zj5754a023d01qqr2";
  };

  # The following patch makes it possible to use a self-signed x509 cert
  # for the cfssl apiserver.
  # TODO: remove patch when PR is merged.
  patches = [
    (fetchpatch {
      url    = "https://github.com/cloudflare/certmgr/pull/51.patch";
      sha256 = "1s5sv9199p9mxq3sci7njhm2j2gin0w86yymjk9w0y5aqawd63zc";
    })
  ];

  meta = with stdenv.lib; {
    homepage = https://cfssl.org/;
    description = "Cloudflare's certificate manager";
    platforms = platforms.linux;
    license = licenses.bsd2;
    maintainers = with maintainers; [ johanot srhb ];
  };
}
