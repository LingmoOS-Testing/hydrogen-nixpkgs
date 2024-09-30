{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv, qtbase, quickcontrols2, x11extras, kwindowsystem5 } :

let
  pkgname = "lingmoui";
  version = "2.2.0";

in

pkgs.lib.overridePkgs {
  lingmoui = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = "aur";
      rev = "refs/tags/${version}";
      sha256 = "sha256a706107c58c302be95698e548cff2696fc9e4491b50394c18591d288dd86f3f4";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase quickcontrols2 x11extras kwindowsystem5
      ];
    };

    # Explicitly specify dependencies
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
      description = "A GUI library based on QQC2 (Qt Quick Controls 2), every Lingmo application uses it.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
      # Consider adding categories
      # categories = [ pkgs.stdenv.pkgs.devel ];
    };
  };
}
