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
    Linux_x86_64 = "065ch0a5kc5plikcgil9s9ggyy9afwrw5nvbs4868hw4f0dbxsnd";
    Linux_arm64 = "1sz5vry4wz0fk681jkfbqjp8f74rahsbqfs4zq1y0j8hhxz8ham7";
    Darwin_x86_64 = "0455kcj164bmfngfd5lr2vgq2kz270wi6nsgak8kxl442rfl71dd";
    Darwin_arm64 = "193r46bnf55n8h24qidl9jbzi2bl3y843sl2k65298iq85wks6as";
  };

  mapPlatformToArchitecture = platform:
    {
      "x86_64" = "x86_64";
      "aarch64" = "arm64";
    }.${platform.parsed.cpu.name} or (throw
      "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "v1.18.1";

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
