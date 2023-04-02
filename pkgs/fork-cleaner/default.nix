{ buildGoModule, fetchFromGitHub, lib, ... }:
buildGoModule rec {
  pname = "fork-cleaner";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "caarlos0";
    repo = "fork-cleaner";
    rev = "v${version}";
    sha256 = "";
  };

  vendorSha256 = "";

  meta = with lib; {
    description = "Quickly clean up unused forks on your github account.";
    homepage = "https://github.com/caarlos0/fork-cleaner";
    license = licenses.mit;
  };
}
