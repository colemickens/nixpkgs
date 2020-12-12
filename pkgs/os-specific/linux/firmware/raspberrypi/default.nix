{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "raspberrypi-firmware";
  version = "1.20201201";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = version;
    sha256 = "sha256-dnRKUD8gBpq9YawuVp8k7NNx6hdSbMtzEh17ceZQ0Cc=";
  };

  installPhase = ''
    mkdir -p $out/share/raspberrypi/boot
    cp -R boot/* $out/share/raspberrypi/boot
  '';

  dontFixup = true;

  meta = with stdenv.lib; {
    description = "Firmware for the Raspberry Pi board";
    homepage = "https://github.com/raspberrypi/firmware";
    license = licenses.unfreeRedistributableFirmware; # See https://github.com/raspberrypi/firmware/blob/master/boot/LICENCE.broadcom
    maintainers = with maintainers; [ dezgeg tavyc ];
  };
}
