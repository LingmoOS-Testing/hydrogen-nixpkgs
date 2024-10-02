{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv, qtbase, quickcontrols2, kwindowsystem5, kio } :

let
  pkgname = "lingmo-filemanager";
  version = "0.8";

in

pkgs.lib.overridePkgs {
  lingmo-filemanager = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = "lingmo-filemanager";
      rev = "refs/tags/${version}";
      sha256 = "sha256e685f2ca83ac31b0227cf3480e925542fa026beeee057a77c375f8d89f0d8047";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase quickcontrols2 kwindowsystem5 kio
      ];
    };

    # Explicitly specify dependencies
    buildInputs = [ cmake extra-cmake-modules ];

    # Customize build and install phases
    mkDerivation {
      configurePhase = "cmake . --build=${stdenv.outPkgs}/bin/packager --config=release";
      buildPhase = make;
      installPhase = pkgs.lib.installPhase {
        src = ".";
        buildInputs = buildInputs;
      };
    };

    meta = with lib; {
      description = "A file manager that simple to use, beautiful, and retain the classic PC interactive design used by LingmoOS.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}