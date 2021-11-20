{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, dpkg }:

stdenv.mkDerivation rec {
  pname = "popcorntime";
  version = "0.4.7";

  src = fetchurl {
    url = "https://github.com/popcorn-official/popcorn-desktop/releases/download/v${version}/Popcorn-Time-${version}-amd64.deb";
    sha256 = "sha256-QRVgo4Wrpop+pzCdkfYGyQxQBRTmg84vG8rpDNu+YiI=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [ dpkg ];

  dontUnpack = true;
  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    mkdir -p $out
    dpkg -x $src $out
  '';

  meta = with lib; {
    description = "BitTorrent client that includes an integrated media player";
    homepage = "https://github.com/popcorn-official/popcorn-desktop";
    # license = licenses.gpl;
    platforms = platforms.linux;
    maintainers = with maintainers; [ onny ];
  };
}
