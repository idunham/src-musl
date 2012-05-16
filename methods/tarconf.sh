# Support for building well-behaved autoconf-based tools from tarball
case $1 in
	get)
		[ -e "${package}-${VER}.${FMT}" ] || \
		curl "$MIR_PKG/${package}-${VER}.${FMT}" -o "${package}-${VER}.${FMT}"
		[ -d "${package}-${VER}/" ] || tar xf "${package}-${VER}.${FMT}" 
		;;
	patch)
		rm -r "${package}-${VER}"
		$package get
		cd "${package}-${VER}/" && \
		patch -p1 <../patch/${package}.patch
		cd -
		;;
	conf)
		$package get
		[ ! -e "${package}-${VER}/Makefile" ] &&
		cd "${package}-${VER}/" && \
		CC="$CC" CFLAGS="$CFLAGS" $CONF_PKG && cd -
		;;
	build)
		$package conf && \
		cd "${package}-${VER}/" && make CC="$CC" CFLAGS="$CFLAGS"
		cd -
		;;
	clean)
		$package conf && \
		cd "${package}-${VER}/" && make clean
		cd -
		;;
	install)
		$package build && cd "${package}-${VER}" && sudo make install
		cd -
		;;

esac
