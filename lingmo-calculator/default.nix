{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv, qtbase, quickcontrols2 } :

let
  pkgname = "lingmo-calculator";
  version = "0.6.1";

in

pkgs.lib.overridePkgs {
  lingmo-calculator = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = "lingmo-calculator";
      rev = "refs/tags/${version}";
      sha256 = "sha256b0de29daeb1028dfbdf56619f88c464fb4273beade471f0d9896a0736e10c4ad";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase quickcontrols2
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
      description = "A simple calculator.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}
