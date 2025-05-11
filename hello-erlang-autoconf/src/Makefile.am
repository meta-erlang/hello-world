SUFFIXES  = .erl .beam
SUFFIXES += .app .app.src

AM_V_ERLC = $(am__v_ERLC_@AM_V@)
am__v_ERLC_ = $(am__v_ERLC_@AM_DEFAULT_V@)
am__v_ERLC_0 = @echo "  ERLC    " $@;
am__v_ERLC_1 =

AM_V_APP = $(am__v_APP_@AM_V@)
am__v_APP_ = $(am__v_APP_@AM_DEFAULT_V@)
am__v_APP_0 = @echo "  APP     " $@;
am__v_APP_1 =

headers =

sources = \
 hello_app.erl \
 hello_sup.erl \
 hello.erl

beams = $(addsuffix .beam, $(basename $(sources)))

deps = $(addsuffix .Pbeam, $(basename $(sources)))

appdir = $(prefix)/lib/erlang/lib/hello-$(HELLO_VSN)
app_srcdir = $(appdir)/src
app_ebindir = $(appdir)/ebin

app_src_DATA = \
 hello.app.src \
 $(headers) \
 $(sources)

app_ebin_DATA = \
 hello.app \
 $(beams)

EXTRA_DIST = $(app_src_DATA)

CLEANFILES = $(app_ebin_DATA)

DISTCLEANFILES = $(CLEANFILES)

clean-local:
	-rm -f $(deps)

.erl.beam:
	$(AM_V_ERLC)$(ERLC) $(ERLCFLAGS) $(EINC) $<

.erl.Pbeam:
	$(AM_V_ERLC)$(ERLC) $(ERLCFLAGS) $(EINC) -MD $<

.PHONY:

sinclude $(deps)

.app.src.app:
	$(AM_V_APP)$(SED) -e 's;&VSN&;$(HELLO_VSN);' $< > $@
