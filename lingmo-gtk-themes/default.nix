{ pkgs, stdenv, lib, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-gtk-themes";
  version = "2.0.0";

in

pkgs.lib.overridePkgs {
  lingmo-gtk-themes = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha25666b55621337316e30b708dc8284d47d2943c9e00bdde7b1b4f2704012f17583e";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv { };

    # No runtime dependencies listed, so buildInputs is empty
    buildInputs = [ extra-cmake-modules ];

    # Customize build and install phases
    mkDerivation {
      configurePhase = cmake . --build=${stdenv.outPkgs}/bin/packager --config=release;
      buildPhase = make;
      installPhase = pkgs.lib.installPhase {
        src = ".";
        buildInputs = buildInputs;
      };
    };

    meta = with lib; {
      description = "GTK themes for Lingmo OS";
      license = licenses.gpl;
      # Maintainer information
      maintainers = [ maintainers.Intro ];
    };
  };
}