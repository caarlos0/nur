# with import <nixpkgs> { };
{ buildGoModule, fetchFromGitHub, lib, ... }:
buildGoModule rec {
  pname = "xdg-open-svc";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "xdg-open-svc";
    rev = "v${version}";
    sha256 = "sha256-20UljWuWNwiLz3A+4jDucW7j4+8MHA4i4JENRoxH/qc=";
  };

  vendorSha256 = "sha256-qaHsTivC4hgdznEWSKQWKmGEkmeKwIz+0h1PIzYVVm8=";

  ldflags =
    [ "-s" "-w" "-X=main.version=${version}" "-X=main.builtBy=nixpkgs" ];

  meta = with lib; {
    description = "xdg-open as a service";
    homepage = "https://github.com/caarlos0/xdg-open-svc";
    license = licenses.mit;
  };
}
