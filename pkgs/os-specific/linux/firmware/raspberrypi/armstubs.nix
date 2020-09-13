{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

let
  inherit (stdenv.lib) optionals;
in
stdenv.mkDerivation {
  pname = "raspberrypi-armstubs";
  version = "2020-08-03";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "tools";
    rev = "0c39cb5b5ac9851312a38c54f5aea770d976de7a";
    sha256 = "06b80raprar9xhknm1y96cl8zwfhrfbzkply0g0x6yw150l2wlg3";
  };

  NIX_CFLAGS_COMPILE = [
    "-march=armv8-a+crc"
  ];

  preConfigure = ''
    cd armstubs
  '';

  makeFlags = [
    "CC8=${stdenv.cc.targetPrefix}cc"
    "LD8=${stdenv.cc.targetPrefix}ld"
    "OBJCOPY8=${stdenv.cc.targetPrefix}objcopy"
    "OBJDUMP8=${stdenv.cc.targetPrefix}objdump"
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}ld"
    "OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
    "OBJDUMP=${stdenv.cc.targetPrefix}objdump"
  ]
  ++ optionals (stdenv.isAarch64) [ "armstub8.bin" "armstub8-gic.bin" ]
  ++ optionals (stdenv.isAarch32) [ "armstub7.bin" "armstub8-32.bin" "armstub8-32-gic.bin" ]
  ;

  installPhase = ''
    mkdir -vp $out/
    cp -v *.bin $out/
  '';

  meta = with stdenv.lib; {
    description = "Firmware related ARM stubs for the Raspberry Pi";
    homepage = https://github.com/raspberrypi/tools;
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ samueldr ];
  };
}
