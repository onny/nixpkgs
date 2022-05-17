{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, kconfig
, kio
, mauikit
, qtlocation
, exiv2
, kquickimageedit
}:

mkDerivation rec {
  pname = "mauikit-imagetools";
  version = "2.1.2";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kio
    mauikit
    qtlocation
    exiv2
    kquickimageedit
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-imagetools";
    description = "MauiKit Image Tools Components";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ onny ];
  };
}

