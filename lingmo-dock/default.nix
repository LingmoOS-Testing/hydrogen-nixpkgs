{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv, qtbase, quickcontrols2, x11extras, qttools, lingmoui } :

let
  pkgname = "lingmo-dock";
  version = "2.0.2";

in

pkgs.lib.overridePkgs {
  lingmo-dock = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = "lingmo-dock";
      rev = "refs/tags/${version}";
      sha256 = "sha2563b07175e2f24c4579041dd30f725a39d8135a873c0b661405a9dde2fcdd395f3";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase quickcontrols2 x11extras qttools lingmoui
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
      description = "The dock component of LingmoOS, which relies on LingmoUI.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}