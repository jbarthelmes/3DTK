# default file for nix-build

{ nixpkgs ? import <nixpkgs> {}, develop ? true}:

let
  inherit (nixpkgs) pkgs;

  libANN = pkgs.stdenv.mkDerivation rec {
    name = "ANN";
    version = "1.1.2";
    src = pkgs.fetchzip {
      url = "https://www.cs.umd.edu/~mount/ANN/Files/${version}/ann_${version}.tar.gz";
      sha256 = "13ajxa3h3d59d34yziq4rd4j0b6a15ck8f8ycjdalgjx3ifajgrk";
    };
    buildPhase = "make linux-g++";
    installPhase = ''
      mkdir $out
      cp -r bin include lib doc $out
    '';
  };

  newmat = pkgs.stdenv.mkDerivation rec {
    name = "newmat";
    version = "10";
    src = pkgs.fetchzip {
      url = "http://www.robertnz.net/ftp/newmat${version}.tar.gz";
      sha256 = "17flcjb00gmz49l57r7yyd458c64dsmbfw6sk7mzl9yjk3svpr3x";
      stripRoot = false;
    };
    buildPhase = "make -f nm_gnu.mak";
    installPhase = ''
      mkdir -p $out/{include/newmat,lib}
      cp *.h $out/include/newmat
      cp libnewmat.a $out/lib
    '';
  };

  slam6d = pkgs.callPackage ./derivation.nix {
    #inherit newmat; # TODO fix includes
    inherit libANN;
    cgal = null; # TODO mpfr include missing in nixpkgs cgal
  };
in
  if develop then
    (slam6d.override {
      stdenv = pkgs.overrideCC pkgs.stdenv (
        if pkgs.lib.inNixShell then
          pkgs.ccacheWrapper
        else
          pkgs.ccacheWrapper.override {
            extraConfig = ''
              export CCACHE_COMPRESS=1
              export CCACHE_DIR=/var/cache/ccache
              export CCACHE_UMASK=007
            '';
          }
      );
    }).overrideAttrs (old: {
      src = builtins.filterSource (path: type:
        (toString path) != (toString (old.src + "/.git"))
      ) old.src;
    })
  else
    slam6d
