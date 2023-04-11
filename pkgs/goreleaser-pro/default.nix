# based on https://github.com/goreleaser/goreleaser/issues/3537#issuecomment-1458562412
{ pkgs, stdenv, fetchurl, installShellFiles, autoPatchelfHook }:

let
  mapPlatformToName = platform:
    if platform.isDarwin then
      "Darwin"
    else if platform.isLinux then
      "Linux"
    else
      platform.parsed.kernel.name;

  # Use `print-hashes.sh $version` to generate the list below
  suffixToHash = {
    # Use `print-hashes.sh` to generate the list below
    Linux_x86_64 = "1fv8prygaridk6qpr78x91m6jxy00a6f5gdanzih8kgizk11rxip";
    Linux_arm64 = "0s28lkvvxaq3wvmdiy1j3i7i2pfsw77ywb9nkb7163z7jr8i5hh5";
    Darwin_x86_64 = "14g32bii6s6ypg8l3cpf3rz3fa3pa28s6bmzipgblcic71cwwy8p";
    Darwin_arm64 = "0y67ssyf26gj3l6g31hd6khbx44627n8d9cc65fnz19q27a1rqfv";
  };

  mapPlatformToArchitecture = platform:
    {
      "x86_64" = "x86_64";
      "aarch64" = "arm64";
    }.${platform.parsed.cpu.name} or (throw
      "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "v1.17.0";

  mapPlatformToSuffix = platform:
    "${mapPlatformToName platform}_${mapPlatformToArchitecture platform}";

  suffix = mapPlatformToSuffix stdenv.hostPlatform;
in stdenv.mkDerivation {
  pname = "goreleaser-pro";
  version = version;
  src = fetchurl {
    url =
      "https://github.com/goreleaser/goreleaser-pro/releases/download/${version}-pro/goreleaser-pro_${suffix}.tar.gz";
    sha256 =
      suffixToHash.${suffix} or (throw "Missing hash for suffix ${suffix}");
  };
  sourceRoot = "."; # goreleaser doesn't have a folder in the tar.gz file.

  nativeBuildInputs = if pkgs.stdenv.isLinux then [
    autoPatchelfHook
    installShellFiles
  ] else
    [ installShellFiles ];

  installPhase = ''
    mkdir -p $out/bin
    cp -vr ./goreleaser $out/bin/goreleaser
    installManPage ./manpages/goreleaser.1.gz
    installShellCompletion ./completions/*
  '';

  system = builtins.currentSystem;
}
