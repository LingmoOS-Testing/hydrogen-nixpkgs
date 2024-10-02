{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-statusbar";
  version = "2.0.0";

in

pkgs.lib.overridePkgs {
  lingmo-statusbar = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = "lingmo-statusbar";
      rev = "refs/tags/${version}";
      sha256 = "sha25606655741c454cee4728c2cf3e34ca76678eed4af86a620945767de970f0d89ca";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        kwindowsystem5 qt5 qtbase qt5-x11extras qtquickcontrols2 qttools
      ];
    };

    # Explicitly specify extra-cmake-modules as build input
    buildInputs = [ cmake extra-cmake-modules ];

    # Customize build and install phases (remove custom prefix)
    mkDerivation {
      configurePhase = "cmake . --build=${stdenv.outPkgs}/bin/packager --config=release";
      buildPhase = make;
      installPhase = pkgs.lib.installPhase {
        src = ".";
        buildInputs = buildInputs;
      };
    };

    meta = with lib; {
      description = "The status bar for LingmoOS.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}