MODULE_big = manticore
OBJS = pg_manticore.o manticore.o pstring.o stringbuilder.o error.o
EXTENSION = manticore
DATA = manticore--0.3.sql manticore--0.2--0.3.sql manticore--0.1--0.2.sql

PG_CPPFLAGS=`mysql_config --cflags`
SHLIB_LINK=`mysql_config --libs_r`

REGRESS=basic nulls

PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

deb-package:
	echo 'PostgreSQL connector to Sphinx/Manticore Search server' > description-pak
	mkdir doc-pak
	cp README.md doc-pak
	checkinstall -D \
		--install=no \
		--backup=no \
		--pkgname pg-manticore \
		--pkgversion 0.3 \
		--pkglicense MIT \
		--pkggroup database \
		--maintainer 'Andrey Kutejko \<andy128k@gmail.com\>' \
		-y \
		make install
	rm description-pak
	rm -rf doc-pak

