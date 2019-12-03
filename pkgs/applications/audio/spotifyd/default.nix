{ stdenv, fetchFromGitHub, rustPlatform, pkgconfig, openssl, dbus
, withALSA ? true, alsaLib ? null, withPulseAudio ? false, libpulseaudio ? null
, withPortAudio ? false, portaudio ? null }:

let
  features = [ "dbus_mpris" "dbus_keyring" ]
    ++ stdenv.lib.optional withALSA "alsa_backend"
    ++ stdenv.lib.optional withPulseAudio "pulseaudio_backend"
    ++ stdenv.lib.optional withPortAudio "portaudio_backend";
in rustPlatform.buildRustPackage rec {
  pname = "spotifyd";
  version = "0.2.24";

  src = fetchFromGitHub {
    owner = "Spotifyd";
    repo = "spotifyd";
    rev = "v${version}";
    sha256 = "08i0zm7kgprixqjpgaxk7xid1njgj6lmi896jf9fsjqzdzlblqk8";
  };

  cargoSha256 = "0200apqbx769ggjnjr0m72g61ikhml2xak5n1il2pvfx1yf5nw0n";

  cargoBuildFlags = [
    "--no-default-features"
    "--features"
    (stdenv.lib.concatStringsSep "," features)
  ];

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [ openssl dbus ] ++ stdenv.lib.optional withALSA alsaLib
    ++ stdenv.lib.optional withPulseAudio libpulseaudio
    ++ stdenv.lib.optional withPortAudio portaudio;

  doCheck = false;

  postPatch = ''
    substituteInPlace contrib/spotifyd.service --replace "/usr/bin" "$out/bin"
  '';

  postInstall = ''
    install -Dm644 contrib/spotifyd.service $out/lib/systemd/user/spotifyd.service
  '';

  meta = with stdenv.lib; {
    description = "An open source Spotify client running as a UNIX daemon";
    homepage = "https://github.com/Spotifyd/spotifyd";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ anderslundstedt filalex77 marsam ];
    platforms = platforms.unix;
  };
}
