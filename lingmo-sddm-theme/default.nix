{ pkgs, stdenv, lib, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-sddm-theme";
  version = "2.0.1";

in

pkgs.lib.overridePkgs {
  lingmo-sddm-theme = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha25622a30c52a6b0145fadf559d7b71d7f371b2fe343e007d43a3144ab6ce233a85a";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [ sddm ];
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
      description = "SDDM theme for LingmoOS";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}