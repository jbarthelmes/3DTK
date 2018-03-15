{ lib, stdenv,
  cmake,
  boost, freeglut, gmp, libconfig, libpng, mesa, opencv, suitesparse, xlibs,
  withCompactOctree ? false,
  withPMD ? false, ftgl ? null, freetype ? null, # FIXME not finding includes
  withQtShow ? false, qt5 ? null,
  withWxShow ? false, wxGTK ? null,
  withXMLRPC ? true, libxml2 ? null, xmlrpc_c ? null,
  zipSupport ? true, libzip ? null,
  cgal ? null,
  eigen3_3 ? null,
  glfw3 ? null,
  libANN ? null,
  newmat ? null
}:

assert withPMD -> ftgl != null && freetype != null;
assert withQtShow -> qt5 != null;
assert withWxShow -> wxGTK != null;
assert withXMLRPC -> libxml2 != null && xmlrpc_c != null;
assert zipSupport -> libzip != null;

stdenv.mkDerivation rec {
  name = "3dtk";
  version = "1.0";

  src = ./.;

  # Compile-time dependencies
  # Some like GCC are included in stdenv
  nativeBuildInputs = [
    cmake
  ];

  # Library dependencies
  buildInputs = with lib; [
    boost
    freeglut
    gmp
    libpng
    libconfig
    mesa
    opencv
    suitesparse
    xlibs.libXi
    xlibs.libXmu
  ]
  ++ optionals withPMD [ ftgl freetype ]
  ++ optional withQtShow qt5.base
  ++ optional withWxShow wxGTK
  ++ optionals withXMLRPC [ libxml2 xmlrpc_c ]
  ++ optional zipSupport libzip
  ++ builtins.filter (a: a != null) [
    cgal eigen3_3 glfw3 libANN newmat
  ];

  preConfigure = ''
    cmakeFlagsArray=($cmakeFlagsArray -DOUTPUT_DIRECTORY="$out")
  '';

  cmakeFlags = with lib; [
    "-DWITH_PYTHON=OFF" # FIXME boost_python not working
    ]
    ++ optional (!withCompactOctree) "-DWITH_COMPACT_OCTREE=OFF"
    ++ optional (!withPMD) "-DWITH_FTGL=OFF"
    ++ optional (!withQtShow) "-DWITH_QT=OFF"
    ++ optional (!withWxShow) "-DWITH_WXWIDGETS=OFF"
    ++ optional (!withXMLRPC) "-DWITH_XMLRPC=OFF"
    ++ optional (!zipSupport) "-DWITH_LIBZIP=OFF"
    ++ optional (cgal == null) "-DWITH_CGAL=OFF"
    ++ optional (eigen3_3 == null) "-DWITH_EIGEN3=OFF"
    ++ optional (ftgl == null) "-DWITH_FTGL=OFF"
    ++ optional (glfw3 == null) "-DWITH_GLFW=OFF"
    ;

  installPhase = ''
    mkdir -p $out
    #cp -r bin doc include lib $out
  '';
}
