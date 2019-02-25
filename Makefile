PG_CONFIG = pg_config

pg_version := $(word 2,$(shell $(PG_CONFIG) --version))
extensions_supported = $(filter-out 6.% 7.% 8.% 9.0%,$(pg_version))
inline_supported = $(filter-out 6.% 7.% 8.%,$(pg_version))
event_trigger_supported = $(filter-out 6.% 7.% 8.% 9.0% 9.1% 9.2%,$(pg_version))


MODULE_big = plsix
OBJS = plsix.o

extension_version = 2

DATA = $(if $(extensions_supported),plsix--unpackaged--1.sql plsix--1--2.sql,plsix.sql)
DATA_built = $(if $(extensions_supported),plsix--$(extension_version).sql)
EXTENSION = plsix

EXTRA_CLEAN = plsix.sql plsix--$(extension_version).sql

REGRESS = init function trigger crlf psql $(if $(inline_supported),inline) $(if $(event_trigger_supported),event_trigger)
REGRESS_OPTS = --inputdir=test


PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

override CFLAGS := $(filter-out -Wmissing-prototypes,$(CFLAGS))


all: plsix.sql

plsix.sql: $(if $(inline_supported),plsix-inline.sql,plsix-noinline.sql)
	cp $< $@

plsix--$(extension_version).sql: plsix.sql
	cp $< $@


version = $(shell git describe --tags)

dist:
	git archive --prefix=plsix-$(version)/ -o plsix-$(version).tar.gz -9 HEAD
