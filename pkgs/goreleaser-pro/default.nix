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
    Linux_x86_64 = "1lj6rr6p6x0gp3d1yckyk0r1sp9lb4cxk50w6wi3ddrazmg3iy4q";
    Linux_arm64 = "0mv0wc3nbqmnmjl3ymnjz1fn16mxlmxi7vnm460ly6gdp7l0p3f0";
    Darwin_x86_64 = "0cp65rzlxhpxsyrl19196hi54ki4l5cqbfvy2pwpf07cx1k6avjg";
    Darwin_arm64 = "0zgyzd2iq9353gify7n3108qwwi176pk5mv1j3gj8rxp8vd97j2i";
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
