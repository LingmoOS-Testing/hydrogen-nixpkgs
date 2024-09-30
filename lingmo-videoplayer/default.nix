{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-videoplayer";
  version = "2.0.0";

in

pkgs.lib.overridePkgs {
  lingmo-videoplayer = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha2562afd37a4b35d834e7b0749009e65cb639e9f163219ee742e63f2cac3b5d590e9";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        mpv qt5 qtbase qtquickcontrols2 qttools
      ];
    };

    # Explicitly specify extra-cmake-modules as build input
    buildInputs = [ cmake extra-cmake-modules ];

    # Customize build and install phases (remove custom prefix)
    mkDerivation {
      configurePhase = cmake . --build=${stdenv.outPkgs}/bin/packager --config=release;
      buildPhase = make;
      installPhase = pkgs.lib.installPhase {
        src = ".";
        buildInputs = buildInputs;
      };
    };

    meta = with lib; {
      description = "Open source video player built using Qt/QML and libmpv.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}