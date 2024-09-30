{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-terminal";
  version = "1.9.9";

in

pkgs.lib.overridePkgs {
  lingmo-terminal = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha256eed57d86d3d299a3ff264f6a0fa0fe477468240465146ebe681757c8fd016a6c";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase qtdeclarative qtquickcontrols2 qt5-x11extras
        qttools qtgraphicaleffects lingmoui
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
      description = "Terminal emulator using LingmoUI as interface style on LingmoOS.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}