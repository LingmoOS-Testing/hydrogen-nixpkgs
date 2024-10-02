{ pkgs, stdenv, lib, qt5, cmake, fetchFromGitHub, buildEnv, qtbase, networkmanager, modemmanager, bluez, kscreen, kio, sensors } :

let
  pkgname = "liblingmo";
  version = "1.9.10";

in

pkgs.lib.overridePkgs {
  liblingmo = pkgs.stdenv.mkDerivation {
    name = "${pkgname}-${version}";

    # Use stdenv.mkDerivation for more control over build environment
    src = fetchFromGitHub {
      owner = "LingmoOS";
      repo = "liblingmo";
      rev = "refs/tags/${version}";
      sha256 = "sha256be89a707f5aaae86bd4e59b0784f82414d380ce530d974d4e1fb62c42c4a4106";
    };

    # Use stdenv.buildEnv to ensure consistent build environment
    buildEnv = stdenv.buildEnv {
      pkgs = with pkgs; [
        qt5 qtbase networkmanager modemmanager bluez kscreen kio sensors
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
      description = "System library for Lingmo applications";
      license = licenses.gpl;
      maintainers = [ maintainers.Intro maintainers.Chun-awa ];
      # Consider adding categories
      # categories = [ pkgs.stdenv.pkgs.devel ];
    };
  };
}
