# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{ system ? builtins.currentSystem, pkgs, lib, fetchurl, installShellFiles }:
let
  shaMap = {
    x86_64-linux = "0qx2adwwy3dgb1g3s3ypjyhcbvv3yk0xq127pv1sa1b57k9n5kjq";
    x86_64-darwin = "01f89xms179h6rsrx00ki097vv3s51iszwr0xmdbgd06b5k9nq1f";
  };

  urlMap = {
    x86_64-linux = "https://github.com/caarlos0-graveyard/test/releases/download/v1.0.7/foo_1.0.7_linux_amd64.tar.gz";
    x86_64-darwin = "https://github.com/caarlos0-graveyard/test/releases/download/v1.0.7/foo_1.0.7_darwin_amd64.tar.gz";
  };
in pkgs.stdenv.mkDerivation {
  pname = "test";
  version = "1.0.7";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./moises $out/bin/moises
  '';

  system = system;

  meta = with lib; {
    description = "a test";
    homepage = "https://test";
    license = licenses.mit;

    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
