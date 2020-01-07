{ stdenv, fetchurl, libGL, xorg, cairo
, libpng, gtk2, glib, gdk-pixbuf, fontconfig, freetype, curl
, dbus-glib, alsaLib, libpulseaudio, systemd, pango
}:

with stdenv.lib;

let

  steamlinkUrl = "https://media.steampowered.com/steamlink/rpi/steamlink_1.0.7_armhf.deb";

  rpathPlugin = makeLibraryPath
    [ libGL
      xorg.libXt
      xorg.libX11
      xorg.libXrender
      cairo
      libpng
      gtk2
      glib
      fontconfig
      freetype
      curl
    ];

  rpathProgram = makeLibraryPath
    [ gdk-pixbuf
      glib
      gtk2
      xorg.libX11
      xorg.libXcomposite
      xorg.libXfixes
      xorg.libXrender
      xorg.libXrandr
      xorg.libXext
      stdenv.cc.cc
      alsaLib
      libpulseaudio
      dbus-glib
      systemd
      curl
      pango
      cairo
    ];

in

stdenv.mkDerivation rec {
  pname = "steamlink";

  src = fetchurl {
    url = "${steamlinkUrl}";
    sha256 = "0bbc3d6997ba22ce712d93e5bc336c894b54fc82";
  };

  unpackPhase = ''
    ar p "$src" data.tar.gz | tar xz
  '';

  installPhase =
    ''
      bin=$out/bin
      mkdir -p $bin
      cp ./usr/bin/steamlink{,deps} $bin/

      for i in libnpgoogletalk.so libppgoogletalk.so libppo1d.so; do
        patchelf --set-rpath "${makeLibraryPath [ stdenv.cc.cc xorg.libX11 ]}:${stdenv.cc.cc.lib}/lib64" $plugins/$i
      done

      for i in libgoogletalkremoting.so libnpo1d.so; do
        patchelf --set-rpath "$out/libexec/google/talkplugin/lib:${rpathPlugin}:${stdenv.cc.cc.lib}/lib64" $plugins/$i
      done

      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${rpathProgram}:${stdenv.cc.cc.lib}/lib64" \
        $bin/steamlink

      # Generate an LD_PRELOAD wrapper to redirect execvp() calls to
      # /opt/../GoogleTalkPlugin.
      preload=$out/libexec/google/talkplugin/libpreload.so
      mkdir -p $(dirname $preload)
      gcc -shared ${./preload.c} -o $preload -ldl -DOUT=\"$out\" -fPIC
      echo $preload > $plugins/extra-ld-preload

      # Prevent a dependency on gcc.
      strip -S $preload
      patchELF $preload
    '';

  dontStrip = true;
  dontPatchELF = true;

  meta = {
    homepage = "https://support.steampowered.com/kb_article.php?ref=6153-IFGH-6589";
    license = stdenv.lib.licenses.unfree;
    maintainers = [ stdenv.lib.maintainers.colemickens ];
  };
}
