# double indirection in POSIX sh
# assigns variables for building a specific package
eval MIR_PKG=$MIR_`echo $PKG`
eval BRN_PKG=$BRN_`echo $PKG`
eval CC_PKG=$CC_`echo $PKG`
eval CFLAGS_PKG=$CFLAGS_`echo $PKG`
# Assign if set
[ "$CFLAGS_PKG" ] 	&& export CFLAGS=$CFLAGS_PKG
[ "$CC_PKG" ] 		&& export CC=$CC_PKG


