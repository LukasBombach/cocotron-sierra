#!/bin/sh
installResources=`pwd`/Resources
scriptResources=$installResources/scripts

read productVersion DSTROOT < "`pwd`/version.txt"


productFolder=/Developer/Cocotron/$productVersion
downloadFolder=$productFolder/Downloads

if [ ""$1"" = "" ];then
  targetPlatform="Windows"
else
  targetPlatform=$1
fi

if [ ""$2"" = "" ];then
  targetArchitecture="i386"
else
  targetArchitecture=$2
fi

if [ ""$3"" = "" ];then
  gccVersion="4.3.1"
else
  gccVersion=$3
fi

BASEDIR=/Developer/Cocotron/$productVersion/$targetPlatform/$targetArchitecture
#PREFIX=`pwd`/../system/i386-mingw32msvc/libjpeg
if [[ "$DSTROOT" == *"../"* ]] ;then
PREFIX=`pwd`/$DSTROOT/libjpeg
else
PREFIX=$DSTROOT/libjpeg
fi


BUILD=/tmp/build_libjepgturbo

mkdir -p $PREFIX


$scriptResources/downloadFilesIfNeeded.sh $downloadFolder http://freefr.dl.sourceforge.net/project/libjpeg-turbo/1.3.0/libjpeg-turbo-1.3.0.tar.gz

mkdir -p $BUILD
cd $BUILD
tar -xvzf $downloadFolder/libjpeg-turbo-1.3.0.tar.gz
cd libjpeg-turbo-1.3.0

pwd 

GCC=$(echo $BASEDIR/gcc-$gccVersion/bin/*gcc)
AS=$(echo $BASEDIR/gcc-$gccVersion/bin/*as)
AR=$(echo $BASEDIR/gcc-$gccVersion/bin/*ar)
RANLIB=$(echo $BASEDIR/gcc-$gccVersion/bin/*ranlib)
TARGET=$($GCC -dumpmachine)
export MAKE="$(which make)"


./configure --prefix="$PREFIX" -host $TARGET AR=$AR AS=$AS CC=$GCC RANLIB=$RANLIB --with-jpeg8 

make && make install
