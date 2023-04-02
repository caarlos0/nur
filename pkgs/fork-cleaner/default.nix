{ buildGoModule, fetchFromGitHub, lib, ... }:
buildGoModule rec {
  pname = "fork-cleaner";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "fork-cleaner";
    rev = "v${version}";
    sha256 = "2vcxbKJsmLSW4GzXEOFE3w7sW4P9vyzr4yBr+eG+R2I=";
  };

  vendorSha256 = "sha256-+2lBn+QTQmJUwIlWkxeY2PkyKsUEfWNUWhdDVjGJun0=";

  ldflags =
    [ "-s" "-w" "-X=main.version=${version}" "-X=main.builtBy=nixpkgs" ];

  meta = with lib; {
    description = "Quickly clean up unused forks on your github account.";
    homepage = "https://github.com/caarlos0/fork-cleaner";
    license = licenses.mit;
  };
}
