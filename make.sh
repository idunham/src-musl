#!/bin/sh
# Shell driver script for building a musl toolchain
# Configuration
. control.env
export PATH=${BINDIR}:${PATH}
egrep  ^[A-Z_]*= control.env |awk -F= '{print $1}' | xargs export 
export CFLAGS="-fno-stack-protector"

musl(){
	export CC=${HOSTCC}
	export CFLAGS="-Os -fno-stack-protector"
	case $1 in
	get)
		[ -d musl/.git ] || git clone "$MIR_MUSL" musl
		;;
	pull)
		cd musl && git checkout "$BRN_MUSL" && \
		  git pull "$MIR_MUSL" "$BRN_MUSL"
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


