{
  lib,
  fetchFromGitHub,
  makeWrapper,
  jujutsu,
  rustPlatform,
  testers,
  lazyjj,
  fetchpatch,
}:
rustPlatform.buildRustPackage rec {
  pname = "lazyjj";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Cretezy";
    repo = "lazyjj";
    rev = "v${version}";
    hash = "sha256-iT6kRzD+w7cb7ZjMt7NfkqwFJOzbt6kxc5vDjI7By84=";
  };

  cargoHash = "sha256-y7yIgM4pIvqsX7LuLU/6P/9oNxsJrg/o/4CqqJ8uitU=";

  postInstall = ''
    wrapProgram $out/bin/lazyjj \
      --prefix PATH : ${lib.makeBinPath [ jujutsu ]}
  '';

  patches = [
    # https://github.com/Cretezy/lazyjj/pull/61
    (fetchpatch {
      name = "adapt_test_traces_to_jj_0.22.0.patch";
      url = "https://github.com/Cretezy/lazyjj/commit/d5e949fb0e62bc93969c27011963582e12bbe3f6.patch";
      hash = "sha256-u+IMLW4iZxMmpa+dwggMfQ4E7ygc0T4I6lvzBcPJT3s=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];

  nativeCheckInputs = [ jujutsu ];

  passthru.tests.version = testers.testVersion { package = lazyjj; };

  meta = with lib; {
    description = "TUI for Jujutsu/jj";
    homepage = "https://github.com/Cretezy/lazyjj";
    mainProgram = "lazyjj";
    license = licenses.asl20;
    maintainers = with maintainers; [ colemickens ];
  };
}
