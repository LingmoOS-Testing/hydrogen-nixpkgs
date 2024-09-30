{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv, qtbase, kcoreaddons, quickcontrols2, libxcursor, x11extras, qttools, graphicaleffects, kwindowsystem5, kidletime, polkit, polkitQt5, xorgServerDevel, xf86InputLibinput, xf86InputSynaptics } :

let
  pkgname = "lingmo-core";
  version = "2.0.1";

in

pkgs.lib.overridePkgs {
  lingmo-core = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha256ee39f817858b8c12643d181bb385c2e23701853c06f9e4facd30e08b3548c144";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase kcoreaddons quickcontrols2 libxcursor x11extras qttools
        graphicaleffects kwindowsystem5 kidletime polkit polkitQt5
        xorgServerDevel xf86InputLibinput xf86InputSynaptics
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
      description = "The core components of LingmoOS, including system backend and session initiation.";
      license = licenses.gpl;
      # Consider adding maintainer information
      maintainers = [ maintainers.Intro maintainers.chun-awa ];
      # Consider adding categories
      # categories = [ pkgs.stdenv.pkgs.devel ];
    };
  };
}