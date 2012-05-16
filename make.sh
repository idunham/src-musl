#!/bin/sh
# Shell driver script for building a musl toolchain
# Configuration
. control.env
export PATH=${BINDIR}:${PATH}
export `egrep  ^[A-Z_]*= control.env |awk -F= '{print $1}' | xargs`
export CFLAGS="-fno-stack-protector -Os -D_GNU_SOURCE"

musl(){
	
	export CC_MUSL=gcc-4.1
	export CFLAGS_MUSL="-O3 -fno-stack-protector"
	export package=musl
	export PKG=MUSL
	export CONF_MUSL="./configure --prefix=$PREFIX --bindir=$BINDIR --enable-gcc-wrapper"
	. methods/vars.sh
	. methods/git.sh
}
linux(){
	CC="$GCC"
	MAJ=3.0
	MIN=31
	package=linux
	FMT=tar.xz
	DIR_PKG=${package}-${MAJ}
	MIR_PKG="http://www.kernel.org/pub/linux/kernel/v3.x"
	TMP_PKG="`pwd`/build/lin"
	mkdir -p $TMP_PKG
	case $1 in
	get)
	    rm -rf ${DIR_PKG}
	    [ -e "${DIR_PKG}.${FMT}" ] || \
		curl ${MIR_PKG}/${DIR_PKG}.${FMT} -o ${DIR_PKG}.${FMT}
	    [ -e "patch-${MAJ}.${MIN}.xz" ] ||
	  	curl ${MIR_PKG}/patch-${MAJ}.${MIN}.xz -o patch-${MAJ}.${MIN}.xz
	    unxz --stdout "${DIR_PKG}.${FMT}" | tar xf - || \
		rm -rf "./${DIR_PKG}/"
	    cd ${DIR_PKG} && unxz --stdout "../patch-${MAJ}.${MIN}.xz" | patch -p1 
	    cd -
	;;
	config)
	    [ -e ${DIR_PKG}/.config ] || [ -e ${DIR_PKG}/defconfig ] || \
		cp ./.config ${DIR_PKG}/.config && make silentoldconfig
	;;
	header)
	    cd ${DIR_PKG} && make headers_install INSTALL_HDR_PATH=$TMP_PKG \
		HOSTCFLAGS=-D_GNU_SOURCE && \
		cd $TMP_PKG && sudo cp -r * $PREFIX 
	    cd `dirname $TMP_PKG`&& cd ..
	;;
	esac
}
libnl(){
	
	export CFLAGS_LIBNL="-Os -fno-stack-protector"
	export package=libnl
	export PKG=LIBNL
	export CONF_LIBNL="./autogen.sh && ./configure --prefix=$PREFIX --oldincludedir=$PREFIX/include"
	. methods/vars.sh
	. methods/git.sh
}
zlib(){
	package=zlib
	PKG=ZLIB
	CONF_ZLIB="./configure --prefix=${PREFIX}"
	. methods/vars.sh
	. methods/tarconf.sh
}
ncurses(){
	package=ncurses
	PKG=NCURSE
	CONF_NCURSE="./configure --prefix=${PREFIX} --without-cxx --with-falbacks=xterm"
	. methods/vars.sh
	. methods/tarconf.sh
}
linux get
linux header
musl build

#zlib get
#zlib build
zlib install
#libnl build
libnl install

ncurses patch
#ncurses build
ncurses install

