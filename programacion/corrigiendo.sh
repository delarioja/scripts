[ -d $archivo ] && echo "/") || ([ -x $archivo ] && echo "*") || ([ -f $archivo ] && echo "-")
