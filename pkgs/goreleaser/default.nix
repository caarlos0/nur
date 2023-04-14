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
    Linux_x86_64 = "19n9hiffmhy1hlmvqngdyz4g3875lc07qlpbpjmgj34q4v7ji8kw";
    Linux_arm64 = "0k85hxi2508cgxzbl25k81nbr5s1pkp3b3qn3fsp2nz115p8j8ma";
    Darwin_x86_64 = "0g8kf4xvdnalgh4da90967y9ydgb819p6ql19g008cvbnsnad86m";
    Darwin_arm64 = "0s621arpbmb539q5qxw0ijfp1fy8lz7p7qv4ldirq9dp8vma20qr";
  };

  mapPlatformToArchitecture = platform:
    {
      "x86_64" = "x86_64";
      "aarch64" = "arm64";
    }.${platform.parsed.cpu.name} or (throw
      "Unsupported CPU ${platform.parsed.cpu.name}");

  version = "v1.17.1";

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
