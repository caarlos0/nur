# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{ system ? builtins.currentSystem, pkgs, lib, fetchurl, installShellFiles }:
let
  shaMap = {
    x86_64-linux = "0l1jwq5mmcnaz3hzn7krbf11n2yq118k677l1fy4zci70m5a9x6l";
    x86_64-darwin = "1mfmam66pwms953s93p4jpx7nch8vw74s88yasi0dvglh9f0grxx";
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
