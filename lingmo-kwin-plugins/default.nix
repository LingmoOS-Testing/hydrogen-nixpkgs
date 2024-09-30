{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv, kwidgetsaddons, kconfigwidgets } :

let
  pkgname = "lingmo-kwin-plugins";
  version = "1.2.0_1";

in

pkgs.lib.overridePkgs {
  lingmo-kwin-plugins = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha2567480345374769d6d81cd59c2443c49b18863f6c22ae454a9600a5e6b17729362";
    };

    # Explicitly define KDE frameworks and add-ons
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase qtdeclarative kconfig kdecoration kwayland
        kcoreaddons kwindowsystem kwidgetsaddons kconfigwidgets
        plasma-framework5
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
      description = "KWin plugin for LingmoOS";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}