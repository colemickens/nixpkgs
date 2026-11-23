{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "keepass-diff";
  version = "1.2.0-unstable-2026-04-25";

  # https://github.com/Narigo/keepass-diff/pull/85 (bump keepass to 0.12.0),
  # a single commit on top of upstream main
  src = fetchFromGitHub {
    owner = "Narigo";
    repo = "keepass-diff";
    rev = "71bb3d31508d4d6b4caa9d155a14dff383402c28";
    hash = "sha256-jWVEax+DK5dZJsPjCMgYn0C1DFCrZ5ZrMV3/th/vF74=";
  };

  cargoHash = "sha256-r/CiKHds6GGAg4TzdjhEDOK0CtzEFxFDgSpAB02GYds=";

  meta = {
    description = "CLI-tool to diff Keepass (.kdbx) files";
    homepage = "https://keepass-diff.narigo.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wamserma ];
    mainProgram = "keepass-diff";
  };
})
