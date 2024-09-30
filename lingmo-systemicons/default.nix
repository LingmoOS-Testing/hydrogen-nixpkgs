{ pkgs, stdenv, lib, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-systemicons";
  version = "2.0.4";

in

pkgs.lib.overridePkgs {
  lingmo-systemicons = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = pkgname;
      rev = "refs/tags/${version}";
      sha256 = "sha256a54094c292b318530cd6ce846e02d22592b4a575ef0d5c72522a94df3e7be24c";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
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
      description = "Default icon theme for Lingmo.";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
      # Add conflict with cutefish-icons
      conflicts = [ "cutefish-icons" ];
    };
  };
}