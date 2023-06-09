# This file was generated by GoReleaser. DO NOT EDIT.
# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{ system ? builtins.currentSystem, pkgs, lib, fetchurl, installShellFiles }:
let
  shaMap = {
    x86_64-linux = "1dbajimg5ijqblz6v67wh7q4w1i495fr6y0qxplyxp8yqpr9xnjc";
    aarch64-linux = "04zj77h42hkqa3fgj4w0ynkifcpahx6cp1l0zal6vl979668hg3a";
    x86_64-darwin = "162qpfw8ya9amcjd5q7la73gh2hi78jlihgsw262zy60f653qpp5";
    aarch64-darwin = "162qpfw8ya9amcjd5q7la73gh2hi78jlihgsw262zy60f653qpp5";
  };

  urlMap = {
    x86_64-linux = "https://github.com/caarlos0/fork-cleaner/releases/download/v2.3.0/fork-cleaner_2.3.0_linux_amd64.tar.gz";
    aarch64-linux = "https://github.com/caarlos0/fork-cleaner/releases/download/v2.3.0/fork-cleaner_2.3.0_linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/caarlos0/fork-cleaner/releases/download/v2.3.0/fork-cleaner_2.3.0_darwin_all.tar.gz";
    aarch64-darwin = "https://github.com/caarlos0/fork-cleaner/releases/download/v2.3.0/fork-cleaner_2.3.0_darwin_all.tar.gz";
  };
in pkgs.stdenv.mkDerivation {
  pname = "fork-cleaner";
  version = "2.3.0";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./fork-cleaner $out/bin/fork-cleaner
  '';

  system = system;

  meta = with lib; {
    description = "Cleans up old and inactive forks on your github account.";
    homepage = "https://github.com/caarlos0/fork-cleaner";
    license = licenses.mit;

    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
