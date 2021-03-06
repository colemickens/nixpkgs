{ lib, stdenv, fetchFromGitHub, popt, avahi, pkg-config, python, gtk2, runCommand
, gcc, autoconf, automake, which, procps, libiberty_static
, runtimeShell
, sysconfDir ? ""   # set this parameter to override the default value $out/etc
, static ? false
}:

let
  name    = "distcc";
  version = "2016-02-24";
  distcc = stdenv.mkDerivation {
    name = "${name}-${version}";
    src = fetchFromGitHub {
      owner = "distcc";
      repo = "distcc";
      rev = "b2fa4e21b4029e13e2c33f7b03ca43346f2cecb8";
      sha256 = "1vj31wcdas8wy52hy6749mlrca9v6ynycdiigx5ay8pnya9z73c6";
    };

  nativeBuildInputs = [ pkg-config ];
    buildInputs = [popt avahi pkg-config python gtk2 autoconf automake which procps libiberty_static];
    preConfigure =
    ''
      export CPATH=$(ls -d ${gcc.cc}/lib/gcc/*/${gcc.cc.version}/plugin/include)

      configureFlagsArray=( CFLAGS="-O2 -fno-strict-aliasing"
                            CXXFLAGS="-O2 -fno-strict-aliasing"
          --mandir=$out/share/man
                            ${if sysconfDir == "" then "" else "--sysconfdir=${sysconfDir}"}
                            ${if static then "LDFLAGS=-static" else ""}
                            --with${if static == true || popt == null then "" else "out"}-included-popt
                            --with${if avahi != null then "" else "out"}-avahi
                            --with${if gtk2 != null then "" else "out"}-gtk
                            --without-gnome
                            --enable-rfc2553
                            --disable-Werror   # a must on gcc 4.6
                           )
      installFlags="sysconfdir=$out/etc";

      ./autogen.sh
    '';

    # The test suite fails because it uses hard-coded paths, i.e. /usr/bin/gcc.
    doCheck = false;

    passthru = {
      # A derivation that provides gcc and g++ commands, but that
      # will end up calling distcc for the given cacheDir
      #
      # extraConfig is meant to be sh lines exporting environment
      # variables like DISTCC_HOSTS, DISTCC_DIR, ...
      links = extraConfig: (runCommand "distcc-links" { passthru.gcc = gcc.cc; }
        ''
          mkdir -p $out/bin
          if [ -x "${gcc.cc}/bin/gcc" ]; then
            cat > $out/bin/gcc << EOF
            #!${runtimeShell}
            ${extraConfig}
            exec ${distcc}/bin/distcc gcc "\$@"
          EOF
            chmod +x $out/bin/gcc
          fi
          if [ -x "${gcc.cc}/bin/g++" ]; then
            cat > $out/bin/g++ << EOF
            #!${runtimeShell}
            ${extraConfig}
            exec ${distcc}/bin/distcc g++ "\$@"
          EOF
            chmod +x $out/bin/g++
          fi
        '');
    };

    meta = {
      description = "A fast, free distributed C/C++ compiler";
      homepage = "http://distcc.org";
      license = "GPL";

      platforms = lib.platforms.linux;
      maintainers = with lib.maintainers; [ anderspapitto ];
    };
  };
in
  distcc
