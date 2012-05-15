#!/bin/sh
# Shell driver script for building a musl toolchain
# Configuration
. control.env
export PATH=${BINDIR}:${PATH}
export `egrep  ^[A-Z_]*= control.env |awk -F= '{print $1}' | xargs`
export CFLAGS="-fno-stack-protector"

musl(){
	
	export CC_MUSL=gcc-4.1
	export CFLAGS_MUSL="-O3 -fno-stack-protector"
	export package=musl
	export PKG=MUSL
	export CONF_MUSL="./configure --prefix=$PREFIX --bindir=$BINDIR --enable-gcc-wrapper"
	. methods/vars.sh
	. methods/git.sh
}

musl build


