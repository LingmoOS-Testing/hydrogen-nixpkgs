{ pkgs, stdenv, lib, cmake, fetchFromGitHub, buildEnv } :

let
  pkgname = "lingmo-cursor-themes";
  version = "2.0.1";

in

pkgs.lib.overridePkgs {
  lingmo-cursor-themes = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = "lingmo-cursor-themes";
      rev = "refs/tags/${version}";
      sha256 = "sha256a088c15091066d54f83e1f0769eb896b62ca35a98ec1c66a90eee632c49a22f7";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv { };

    # No runtime dependencies listed, so buildInputs is empty
    buildInputs = [];

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
      description = "Lingmo OS Cursor Themes";
      license = licenses.gpl;
      # Add maintainer information with email addresses
      maintainers = [ maintainers.chun-awa maintainers.Intro ];
    };
  };
}