{ lib
, fetchFromGitHub
, rustPlatform
# , autoPatchelfHook
}:

rustPlatform.buildRustPackage rec {
  pname = "apftool-rs";
  version = "unstable-2024-01-05";

  src = fetchFromGitHub {
    owner = "suyulin";
    repo = "apftool-rs";
    rev = "92d8a1b88cb79a53f9e4a70fecee481710d3565b";
    hash = "sha256-0+eKxaLKZBRLdydXxUbifFfFncAbthUn7AB8QieWaXM=";
  };

  cargoHash = "sha256-tijhuiuJhOirnRdDXRNafh3SxBmX65zPE5HJnHBUj30=";

  # No tests exist
  # doCheck = false;

  # buildInputs = [ stdenv.cc.cc.lib ];
  # nativeBuildInputs = [ autoPatchelfHook ];

  # runtimeDependencies = [
  #   wayland
  #   libGL
  #   libxkbcommon
  # ];

  # passthru.tests.version = testers.testVersion {
  #   package = aphorme;
  #   command = "aphorme --version";
  #   version = "aphorme ${version}";
  # };

  meta = {
    description = "About Tools for Rockchip image unpack tool";
    mainProgram = "apftool-rs";
    homepage = "https://github.com/suyulin/apftool-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [];
    platforms = lib.platforms.linux;
  };
}
