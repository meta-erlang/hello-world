# Based on c_src.mk from erlang.mk by Loic Hoguin <essen@ninenines.eu>

CURDIR := $(shell pwd)
BASEDIR := $(abspath $(CURDIR)/..)

PROJECT ?= $(notdir $(BASEDIR))
PROJECT := $(strip $(PROJECT))

PKG_CONFIG_ERL_EI = $(shell pkg-config --exists erl_ei; echo $$?)
PKG_CONFIG_ERL_ERTS = $(shell pkg-config --exists erl_erts; echo $$?)

ifeq ($(PKG_CONFIG_ERL_EI), 0)
ERL_INTERFACE_INCLUDE_DIR = $(shell pkg-config --cflags erl_ei)
ERL_INTERFACE_LIB_DIR = $(shell pkg-config --libs erl_ei)

CFLAGS += $(ERL_INTERFACE_INCLUDE_DIR)
CXXFLAGS += $(ERL_INTERFACE_INCLUDE_DIR)
LDLIBS += $(ERL_INTERFACE_LIB_DIR)
else
ERL_INTERFACE_INCLUDE_DIR = $(shell erl -noshell -s init stop -eval "io:format(\"~ts\", [code:lib_dir(erl_interface, include)]).")
ERL_INTERFACE_LIB_DIR = $(shell erl -noshell -s init stop -eval "io:format(\"~ts\", [code:lib_dir(erl_interface, lib)]).")

CFLAGS += -I $(ERL_INTERFACE_INCLUDE_DIR)
CXXFLAGS += -I $(ERL_INTERFACE_INCLUDE_DIR)
LDLIBS += -L $(ERL_INTERFACE_LIB_DIR) -lei
endif

ifeq ($(PKG_CONFIG_ERL_ERTS), 0)
ERTS_INCLUDE_DIR = $(shell pkg-config --cflags erl_erts)

CFLAGS += $(ERTS_INCLUDE_DIR)
CXXFLAGS += $(ERTS_INCLUDE_DIR)
else
ERTS_INCLUDE_DIR = $(shell erl -noshell -s init stop -eval "io:format(\"~ts/erts-~ts/include/\", [code:root_dir(), erlang:system_info(version)]).")

CFLAGS += -I $(ERTS_INCLUDE_DIR)
CXXFLAGS += -I $(ERTS_INCLUDE_DIR)
endif

C_SRC_DIR = $(CURDIR)
C_SRC_NIF = $(CURDIR)/../priv/bcrypt_nif.so
C_SRC_PORT = $(CURDIR)/../priv/bcrypt

# DRV_LDFLAGS = -shared $(ERL_LDFLAGS) -lpthread
DRV_CFLAGS = -Ic_src -Wall -O3 -fPIC $(ERL_CFLAGS)

# System type and C compiler/flags.

UNAME_SYS := $(shell uname -s)
ifeq ($(UNAME_SYS), Darwin)
	CC ?= cc
	CFLAGS ?= -O3 -std=c99 -arch x86_64 -Wall -Wmissing-prototypes
	LDFLAGS ?= -arch x86_64 -flat_namespace -undefined suppress
	DRV_LDFLAGS = -flat_namespace -undefined suppress $(ERL_LDFLAGS)
else ifeq ($(UNAME_SYS), Linux)
	CC ?= gcc
	CFLAGS ?= -O3 -std=c99 -finline-functions -Wall -Wmissing-prototypes -D_BSD_SOURCE
	DRV_LDFLAGS = $(ERL_LDFLAGS)
else # FreeBSD
	CC ?= cc
	CFLAGS ?= -O3 -std=c99 -finline-functions -Wall -Wmissing-prototypes
	DRV_LDFLAGS = $(ERL_LDFLAGS)
endif

#   {"DRV_LDFLAGS","-shared $ERL_LDFLAGS -lpthread"},
#   {"darwin", "DRV_LDFLAGS", "-bundle -flat_namespace -undefined suppress $ERL_LDFLAGS -lpthread"},
#   {"solaris", "ERL_LDFLAGS", "-lxnet -lssp -lnsl $ERL_LDFLAGS"},
#   {"DRV_CFLAGS","-Ic_src -Wall -O3 -fPIC $ERL_CFLAGS"},
#   {"CFLAGS", "$CFLAGS -Ic_src -Wall -O3"},
#   {"LDFLAGS", "$LDFLAGS -lpthread"}

CFLAGS += -fPIC -I $(ERTS_INCLUDE_DIR) -I $(ERL_INTERFACE_INCLUDE_DIR)

LDLIBS += -L $(ERL_INTERFACE_LIB_DIR) -lei -lpthread

# Verbosity.

c_verbose_0 = @echo " C     " $(?F);
c_verbose = $(c_verbose_$(V))

cpp_verbose_0 = @echo " CPP   " $(?F);
cpp_verbose = $(cpp_verbose_$(V))

link_verbose_0 = @echo " LD    " $(@F);
link_verbose = $(link_verbose_$(V))

SOURCES := $(shell find $(C_SRC_DIR) -type f \( -name "*.c" -o -name "*.C" -o -name "*.cc" -o -name "*.cpp" \))
OBJECTS = $(addsuffix .o, $(basename $(SOURCES)))

COMPILE_C = $(c_verbose) $(CC) $(CFLAGS) $(CPPFLAGS) -c
COMPILE_CPP = $(cpp_verbose) $(CXX) $(CXXFLAGS) $(CPPFLAGS) -c

all: $(C_SRC_NIF) $(C_SRC_PORT)

$(C_SRC_PORT): $(OBJECTS)
	@mkdir -p $(BASEDIR)/priv/
	$(CC) $(CFLAGS) bcrypt_port.o bcrypt.o blowfish.o $(DRV_LDFLAGS) $(LDLIBS) -o ../priv/bcrypt

$(C_SRC_NIF): $(OBJECTS)
	@mkdir -p $(BASEDIR)/priv/
	$(link_verbose) $(CC) $(OBJECTS) $(LDFLAGS) -shared $(LDLIBS) -o $(C_SRC_NIF)

%.o: %.c
	$(COMPILE_C) $(OUTPUT_OPTION) $<

%.o: %.cc
	$(COMPILE_CPP) $(OUTPUT_OPTION) $<

%.o: %.C
	$(COMPILE_CPP) $(OUTPUT_OPTION) $<

%.o: %.cpp
	$(COMPILE_CPP) $(OUTPUT_OPTION) $<

clean:
	@rm -f $(C_SRC_OUTPUT) $(OBJECTS)
