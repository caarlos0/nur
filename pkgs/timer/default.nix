# This file was generated by GoReleaser. DO NOT EDIT.
# vim: set ft=nix ts=2 sw=2 sts=2 et sta
{
system ? builtins.currentSystem
, pkgs
, lib
, fetchurl
, installShellFiles
}:
let
  shaMap = {
    x86_64-linux = "1kv14b3yc1fa45yw2xmwrwz7xsc05xxcjbayb54x81v1pm0sggsw";
    aarch64-linux = "0kykr3bc3663jhvcx46hv5ri44h85wmfafhxk0sba5q49vhhsmva";
    x86_64-darwin = "1w1cjs3b4095i0m4hgg7ndc9ccfnivpdam0b4a5d0vwm9xbjnlkz";
    aarch64-darwin = "1w1cjs3b4095i0m4hgg7ndc9ccfnivpdam0b4a5d0vwm9xbjnlkz";
  };

  urlMap = {
    x86_64-linux = "https://github.com/caarlos0/timer/releases/download/v1.4.1/timer_linux_amd64.tar.gz";
    aarch64-linux = "https://github.com/caarlos0/timer/releases/download/v1.4.1/timer_linux_arm64.tar.gz";
    x86_64-darwin = "https://github.com/caarlos0/timer/releases/download/v1.4.1/timer_darwin_all.tar.gz";
    aarch64-darwin = "https://github.com/caarlos0/timer/releases/download/v1.4.1/timer_darwin_all.tar.gz";
  };
in
pkgs.stdenv.mkDerivation {
  pname = "timer";
  version = "1.4.1";
  src = fetchurl {
    url = urlMap.${system};
    sha256 = shaMap.${system};
  };

  sourceRoot = ".";

  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./timer $out/bin/timer
    installShellCompletion ./completions/*
    installManPage ./manpages/timer.1.gz
  '';

  system = system;

  meta = {
    description = "Timer is like sleep, but reports progress.";
    homepage = "https://github.com/caarlos0/timer";
    license = lib.licenses.mit;

    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
}
