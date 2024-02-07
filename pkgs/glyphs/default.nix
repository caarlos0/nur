{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
}:
buildGoModule {
  pname = "glyphs";
  version = "2024-02-06";

  src = fetchFromGitHub {
    owner = "maaslalani";
    repo = "glyphs";
    rev = "main";
    hash = "sha256-3Sza+Ol0Cddyh36D/M29kRqMrotapy3Sq3Q0/W1FQHc=";
  };

  vendorHash = "sha256-R1M74SGmooHIsFUkqF4Vj52znKDsXyezrmL9o3fBDws=";

  patches = [
    (fetchpatch {
      url = "https://github.com/maaslalani/glyphs/pull/2/commits/1b551d947e93162b984ca96a223332db08d6737c.patch";
      hash = "sha256-MfeI/A06HbyWPP4wroK6LoEGKrMGhh2TxDyeBhWOMSM=";
    })
  ];

  doCheck = false;

  meta = with lib; {
    description = "Unicode symbols on the command line";
    homepage = "https://github.com/maaslalani/glyphs";
    changelog = "https://github.com/maaslalani/glyphs/commits";
    maintainers = with maintainers; [ caarlos0 ];
    mainProgram = "glyphs";
  };
}
