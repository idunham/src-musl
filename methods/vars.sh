# double indirection in POSIX sh
# assigns variables for building a specific package
eval export MIR_PKG=\$MIR_`echo $PKG`
eval export BRN_PKG=\$BRN_`echo $PKG`
eval export CC_PKG=\$CC_`echo $PKG`
eval export CONF_PKG=\$CONF_`echo $PKG`
eval export CFLAGS_PKG=\$CFLAGS_`echo $PKG`
# Assign if set
[ "$CFLAGS_PKG" ] 	&& export CFLAGS=$CFLAGS_PKG
[ "$CC_PKG" ] 		&& export CC=$CC_PKG


