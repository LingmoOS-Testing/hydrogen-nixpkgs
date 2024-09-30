{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-settings";
  version = "2.1.5";

in

pkgs.lib.overridePkgs {
  lingmo-settings = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha256fe747160a9aa44e29ff24fc7c1451d7cc25f8603aad890e232207978e84a2009";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase qtquickcontrols2 qt5-x11extras freetype2 fontconfig
        networkmanager-qt modemmanager-qt libqtxdg lingmoui
      ];
    };

    # Explicitly specify extra-cmake-modules as build input
    buildInputs = [ cmake extra-cmake-modules ];

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
      description = "The system settings application for LingmoOS uses LingmoUI as the interface style.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}