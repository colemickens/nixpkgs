{ stdenv, fetchFromGitHub, fzy }:

stdenv.mkDerivation rec {
  pname = "zsh-fzy-unstable";
  version = "2019-11-25";

  src = fetchFromGitHub {
    owner = "aperezdc";
    repo = "zsh-fzy";
    rev = "923364fabf5e8731f2f0d02c66946a7b6a4c3b13";
    sha256 = "15kc5qcwfmi8p1nyykmnjp32lz8zn1ji8w6aly1pfcg0l62wm26q";
  };

  postPatch = ''
    set -x
    set -e
    substituteInPlace fzy-tmux \
      --replace \
        '/bin/zsh' '/usr/bin/env zsh' \
      --replace \
        'fzy ''${opts}' \
        '${fzy}/bin/fzy ''${opts}' \
      --replace \
        'exec fzy' \
        'exec ${fzy}/bin/fzy'

    substituteInPlace zsh-fzy.plugin.zsh \
      --replace \
        '/bin/zsh' '/usr/bin/env zsh' \
      --replace \
        'ZSH_FZY_TMUX="''${0:A:h}/fzy-tmux"' \
        'ZSH_FZY_TMUX="${placeholder "out"}/share/zsh/plugins/zsh-fzy/fzy-tmux"' \
      --replace \
        'ZSH_FZY=$(command -v fzy)' \
        'ZSH_FZY="${placeholder "out"}/share/zsh/plugins/zsh-fzy/zsh-fzy.plugin.zsh"'
      set +x
  '';

  dontBuild = true;

  installPhase = ''
    install -Dm0777 zsh-fzy.plugin.zsh $out/share/zsh/plugins/zsh-fzy/zsh-fzy.plugin.zsh
    install -Dm0777 fzy-tmux $out/share/zsh/plugins/zsh-fzy/fzy-tmux
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/aperezdc/fzf-zsh";
    description = " Use the fzy fuzzy-finder in Zsh";
    # license = licenses.mit; # no license specified
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.unix;
  };
}
