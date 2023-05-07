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
    Linux_x86_64 = "16lldicfw8xrsdby72vsyzn33d4adwjnqqna88nnb3km9i4s9ddr";
    Linux_arm64 = "1hy2sfaa793lgy7dpp15iximj4f2kd6515f5rya41p366k9ky8m3";
    Darwin_x86_64 = "0jjpa5agdxkpf36913l7jz9mrnr888i4jwyyf3sk062hhs9chj61";
    Darwin_arm64 = "0fq06yrigqpp360b1j0ysi3br9j344404rlgx0m7fp3gyv6914hn";
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
