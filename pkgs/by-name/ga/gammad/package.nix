{
  lib,
  stdenv,
  fetchFromGitHub,
  libdrm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gammad";
  version = "0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "nedimzecic";
    repo = "gammad";
    rev = "bb88b0f19be7dc9c5761d5a58cafd677f43095d3";
    hash = "sha256-7iB8Khi2jwTQpL77t8bWOtCoZqQgKxZzyE/iVk+cg8A=";
  };

  buildInputs = [ libdrm ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev libdrm}/include/libdrm";

  installPhase = ''
    runHook preInstall
    install -Dm755 gammad $out/bin/gammad
    runHook postInstall
  '';

  meta = {
    description = "Lightweight Linux utility for applying gamma correction to display outputs using DRM/KMS";
    homepage = "https://github.com/nedimzecic/gammad";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ colemickens ];
    mainProgram = "gammad";
    platforms = lib.platforms.linux;
  };
})
