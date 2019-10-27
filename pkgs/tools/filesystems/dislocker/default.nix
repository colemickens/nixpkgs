{ stdenv, fetchFromGitHub
, cmake
, polarssl , fuse
}:
with stdenv.lib;
stdenv.mkDerivation {
  pname = "dislocker";
  version = "unstable-2019-07-26";

  src = fetchFromGitHub {
    owner = "aorimn";
    repo = "dislocker";
    rev = "bc513ab178710a041870a47d19c4a4709743e441";
    sha256 = "12nvd0bh0yjkx9gws5mlj6pkjp86j0zvpr8y02mvr941cs4lcgdp";
  };

  buildInputs = [ cmake fuse polarssl ];

  meta = {
    description = "Read BitLocker encrypted partitions in Linux";
    homepage    = https://github.com/aorimn/dislocker;
    license     = licenses.gpl2;
    maintainers = with maintainers; [ elitak ];
    platforms   = platforms.linux;
  };
}
