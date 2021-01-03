{ stdenv, rustPlatform, fetchFromGitHub
, pkg-config, libevdev, openssl, llvmPackages_latest, linuxHeaders }:

let
  metadata = import ./metadata.nix;
in
rustPlatform.buildRustPackage rec {
  pname = "rkvm";
  version = metadata.rev;

  src = fetchFromGitHub {
    owner = "htrefil";
    repo = pname;
    rev = "ec404c69b38f7feff5103f898612734ee8d7ee95";
    sha256 = "sha256-YZXHbZ71EsSyAtTenQ4rgp1fJbatkk7BW4Cmr/RpyXc=";
  };

  cargoSha256 = "sha256-1sxP74xt3DGCAhY6Dolaz2JB3Q6CTvtkgln08AMGmc0=";

  postPatch = ''
    sed -i 's|.clang_arg("-I/usr/include/libevdev-1.0/")|.clang_arg("-I${libevdev}/include/libevdev-1.0").clang_arg("-I${linuxHeaders}/include")|g' ./input/build.rs
  '';

  nativeBuildInputs = [ pkg-config openssl llvmPackages_latest.libclang ];
  LIBCLANG_PATH = "${llvmPackages_latest.libclang}/lib";
  buildInputs = [ libevdev openssl linuxHeaders ];

  meta = with stdenv.lib; {
    description = "Virtual KVM switch for Linux machines";
    homepage = "https://github.com/htrefil/rkvm";
    license = licenses.mit;
    maintainers = [ maintainers.colemickens ];
  };
}
