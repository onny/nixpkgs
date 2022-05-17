{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, kconfig
, kio
, mauikit
, syntax-highlighting
}:

mkDerivation rec {
  pname = "mauikit-texteditor";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kio
    mauikit
    syntax-highlighting
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauikit-texteditor";
    description = "MauiKit Text Editor components";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ onny ];
  };
}
