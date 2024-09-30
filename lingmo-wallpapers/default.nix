{ pkgs, stdenv, lib, cmake, fetchFromGitHub } :

let
  pkgname = "lingmo-wallpapers";
  version = "2.1.0";

in

pkgs.lib.overridePkgs {
  lingmo-wallpapers = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha2568d2de5f7b0de81594afb8c8d05e2a853594ff4ce909921d989c41651d93fab89";
    };

    # No runtime dependencies needed based on the definition (set to empty list)
    buildEnv = stdenv.buildEnv { pkgs = []; };

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
      description = "Built-in wallpapers for LingmoOS.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}