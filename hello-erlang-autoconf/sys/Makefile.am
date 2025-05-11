SUFFIXES = .boot .rel

AM_V_ERL = $(am__v_ERL_@AM_V@)
am__v_ERL_ = $(am__v_ERL_@AM_DEFAULT_V@)
am__v_ERL_0 = @echo "  ERL     " $@;
am__v_ERL_1 =

app_sysconfdir = $(sysconfdir)/hello.d

app_sysconf_DATA = \
 hello.boot

CLEANFILES = $(app_sysconf_DATA)

DISTCLEANFILES = $(CLEANFILES)

.rel.boot:
	$(AM_V_ERL)$(ERL) -noshell -pa $(top_builddir)/src\
	 -s systools make_script $* 'no_warn_sasl' -s erlang halt
