# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{ system ? builtins.currentSystem, pkgs, lib, fetchurl, installShellFiles }:
let
  shaMap = {
    x86_64-linux = "02qyz9vq2h63j1rvzcpi20dm6kp96g1ljhb5phrkb78ygmggl6gb";
    x86_64-darwin = "0cspbg81z67sna25v68nvsh8n006hdcp1i3sx3yd6yjglc50vxzs";
  };

  urlMap = {
    x86_64-linux = "https://github.com/caarlos0-graveyard/test/releases/download/v1.0.6/foo_1.0.6_linux_amd64.tar.gz";
    x86_64-darwin = "https://github.com/caarlos0-graveyard/test/releases/download/v1.0.6/foo_1.0.6_darwin_amd64.tar.gz";
  };
in pkgs.stdenv.mkDerivation {
  pname = "test";
  version = "1.0.6";
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
