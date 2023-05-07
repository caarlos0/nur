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
    Linux_x86_64 = "047spkywhfgcibry6p16y12ynr5mxsl9r88jhqy8zxs7wdihq7l1";
    Linux_arm64 = "0h5jndgv3ifvlvy2r4xjgvqyday2k9jb4h24f7n0rdqidrxgn8pg";
    Darwin_x86_64 = "1f80civ7i0dhnkaqpdmbynwn436fqsl6hyw34cp1airk6gnqwcwm";
    Darwin_arm64 = "0girjxp07srylyq36xk1ska8p68m2fhp05xgyv4wkcl61d6rzv3y";
  };

  mapPlatformToArchitecture = platform:
    {
      "x86_64" = "x86_64";
      "aarch64" = "arm64";
    }.${platform.parsed.cpu.name} or (throw
      "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "v1.18.2";

  mapPlatformToSuffix = platform:
    "${mapPlatformToName platform}_${mapPlatformToArchitecture platform}";

  suffix = mapPlatformToSuffix stdenv.hostPlatform;
in stdenv.mkDerivation {
  pname = "goreleaser";
  version = version;
  src = fetchurl {
    url =
      "https://github.com/goreleaser/goreleaser/releases/download/${version}/goreleaser_${suffix}.tar.gz";
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
