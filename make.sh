#!/bin/sh
# Shell driver script for building a musl toolchain
# Configuration
. control.env
export PATH=${BINDIR}:${PATH}
export `egrep  ^[A-Z_]*= control.env |awk -F= '{print $1}' | xargs`
export CFLAGS="-fno-stack-protector"

musl(){
	
	export CC_MUSL=${HOSTCC}
	export CFLAGS_MUSL="-Os -fno-stack-protector"
	export package=musl
	export PKG=MUSL
	export CONF_MUSL="./configure --prefix=$PREFIX --bindir=$BINDIR --enable-gcc-wrapper"
	. methods/vars.sh
	case $1 in
	get)
		[ -d musl/.git ] || git clone "$MIR_PKG" musl
		;;
	pull)
		cd musl && git checkout "$BRN_PKG" && \
		  git pull "$MIR_PKG" "$BRN_PKG"
		cd -
		;;
	conf)
		musl get && cd musl && [ -e config.mak ] || \
		./configure --prefix=${PREFIX} --bindir=${BINDIR} \
		--enable-gcc-wrapper
		cd -
		;;
	build)
		musl conf && cd musl && make clean && make
		cd -
		;;
	install)
		musl build && cd musl && sudo make install
		cd -
		;;
	esac
}

musl build


