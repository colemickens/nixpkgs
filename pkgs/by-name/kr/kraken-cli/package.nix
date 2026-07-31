{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cacert,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kraken-cli";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "krakenfx";
    repo = "kraken-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IHWpgAsk2Py8LpCn7dYD5BJaeID5QLGnXBFXccZTD5I=";
  };

  cargoHash = "sha256-p5PHNtqe1sn2FJO7M8G0tSAaXvV4ShEAySWc80JOhJg=";

  # orderbook_l3_returns_error_not_panic requires network access to api.kraken.com
  checkFlags = [ "--skip=orderbook_l3_returns_error_not_panic" ];

  # reqwest's rustls-platform-verifier needs a CA bundle in the build sandbox
  nativeCheckInputs = [ cacert ];
  env.SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-native CLI for trading crypto, stocks, forex, and derivatives on Kraken";
    homepage = "https://github.com/krakenfx/kraken-cli";
    changelog = "https://github.com/krakenfx/kraken-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ colemickens ];
    mainProgram = "kraken";
    platforms = lib.platforms.unix;
  };
})
