{ lib
, buildNpmPackage
, fetchFromGitHub
, nix-update-script
,
}:

buildNpmPackage (finalAttrs: {
  pname = "lunchmoney-mcp";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "akutishevsky";
    repo = "lunchmoney-mcp";
    rev = "mcpb-${finalAttrs.version}";
    hash = "sha256-r6CyrxYES2JLMA9KdTajMU5+0eeHmWwRq9YsafwEaEM=";
  };

  npmDepsHash = "sha256-jYR70nmrc0obEV0wR/HI1ytlKk2JVXTFtE07Lb870Es=";

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
      ];
    };
  };

  meta = {
    description = "Model Context Protocol server for LunchMoney personal finance management";
    homepage = "https://github.com/akutishevsky/lunchmoney-mcp";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "lunchmoney-mcp";
    platforms = lib.platforms.all;
  };
})
