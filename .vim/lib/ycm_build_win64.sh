#!/bin/bash

cwd=$(pwd)

PACKAGES="gcc g++ mingw32-make cmake python"
for package in $PACKAGES; do
  if !which $package; then
    echo "required package not found: $package" 1>&2
    exit 1
  fi
done

if ! grep 'set(CMAKE_CXX_FLAGS_RELEASE' third_party/ycmd/cpp/CMakeLists.txt; then
  cat <<'EOM' >> third_party/ycmd/cpp/CMakeLists.txt
set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -include cmath")
add_definitions(-DBOOST_PYTHON_SOURCE)
add_definitions(-DBOOST_THREAD_BUILD_DLL)
add_definitions(-DMS_WIN64)
EOM
fi
sed -ie 's/^namespace boost/\/\/ \0/' third_party/ycmd/cpp/ycm/ycm_core.cpp
sed -ie 's/^void tss_cleanup_implemented/\/\/ \0/' third_party/ycmd/cpp/ycm/ycm_core.cpp
sed -ie 's/^};/\/\/ \0/' third_party/ycmd/cpp/ycm/ycm_core.cpp

mkdir build
cd build
# cmake -G "MinGW Makefiles" . ../third_party/ycmd/cpp \
#   -D"CMAKE_MAKE_PROGRAM:PATH=$(cygpath -w `which make` | sed -e 's/\\/\//g')"
cmake -G "MinGW Makefiles" . ../third_party/ycmd/cpp \
  -D"CMAKE_MAKE_PROGRAM:PATH=$(cygpath -w `which mingw32-make` | sed -e 's/\\/\//g')"
mingw32-make ycm_core
mingw32-make ycm_support_libs

cd $cwd
## for old version
# cp third_party/ycm/ycm_core.pyd python/
cd third_party/ycm/third_party/Omnisharp
COMPILER=msbuild
if ! which $COMPILER; then
  FWDIR=$(cygpath -u $WINDIR/Microsoft.NET/Framework64/)
  [ ! -e "${FWDIR}" ] && FWDIR=$(cygpath -u $WINDIR/Microsoft.NET/Framework/)
  BINDIR=$(/usr/bin/find $FWDIR -type d -maxdepth 1 | /usr/bin/sort -r | /usr/bin/head -1)
  COMPILER=$BINDIR/msbuild
fi
$COMPILER

cd $cwd
cd third_party/ycm/third_party/gocode
go build
