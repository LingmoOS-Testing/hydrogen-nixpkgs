{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-texteditor";
  version = "2.0.0";

in

pkgs.lib.overridePkgs {
  lingmo-texteditor = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${pkgver}";
      sha256 = "sha256d8ac2f6e5e3af0ab841c6141c2d9b2bb1bb32c43367565e330f05adc7b04eb74";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase qtquickcontrols qttools syntax-highlighting5
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
      description = "An easy-to-use and aesthetically pleasing text editor for Lingmo OS.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}