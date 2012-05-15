	case $1 in
	get)
		[ -d $package/.git ] || git clone "$MIR_PKG" $package
		;;
	pull)
		cd $package && git checkout "$BRN_PKG" && \
		  git pull "$MIR_PKG" "$BRN_PKG"
		cd -
		;;
	conf)
		$package get && cd $package && [ -e config.mak ] || \
		$CONF_PKG
		cd -
		;;
	build)
		$package conf && cd $package && make clean && make
		cd -
		;;
	install)
		$package build && cd $package && sudo make install
		cd -
		;;
	esac
