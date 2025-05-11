AC_PREREQ([2.68])
AC_INIT([hello], [0.1], [], [],
 [https://github.com/egcrowe/hello.git])
AM_INIT_AUTOMAKE([-Werror -Wno-override foreign])
AM_SILENT_RULES([yes])

# Checks for programs.

AC_PATH_PROG(SED, sed)

AC_ERLANG_NEED_ERLC
AC_ERLANG_NEED_ERL
AC_ERLANG_SUBST_ERTS_VER
AC_ERLANG_CHECK_LIB([kernel],[],[])
AC_ERLANG_CHECK_LIB([stdlib],[],[])

# Checks for header files.

# Checks for library functions.

dnl ----------------------------------------------------------------------
dnl Set version
dnl ----------------------------------------------------------------------

HELLO_VSN=`git describe --tags --always 2>/dev/null`
if test "$HELLO_VSN" = "";
  then HELLO_VSN=`cat $srcdir/HELLO_VSN`
  else echo $HELLO_VSN>$srcdir/HELLO_VSN
fi
AC_SUBST(HELLO_VSN)

AC_CONFIG_FILES([Makefile
                 src/Makefile
                 sys/Makefile
                 sys/hello.rel
                 sys/hello.start
                 sys/hello.stop])

AC_OUTPUT
