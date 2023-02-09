-include config.mk

CFLAGS = $(CFLAGS_DEBUG)
CFLAGS             += -Wall -pedantic
CFLAGS 			   += -I $(CURDIR)/include
CFLAGS             += $(CFLAGS_LUA)
CFLAGS             += -DCLP_PATH=\"${SHAREPREFIX}/clp\"
CFLAGS             += -DSRC_LUA_PATH=\"${ABS_SRCDIR}/lua\"
LDFLAGS             = $(LDFLAGS_LUA)

SRC                 = clp.c
ELF                 = clp
TEST_SRC            = tests/tests.c
TEST_ELF            = tests/tests

ALL: $(ELF)

config.mk:
	@touch $@

clp: config.mk clp.o cli.c
	$(CC) cli.c $(CFLAGS) $(LDFLAGS) clp.o -o clp

$(TEST_ELF): clp.o $(TEST_SRC)
	$(CC) $(TEST_SRC) $(CFLAGS) $(LDFLAGS) $(CFLAGS_PCRE2) $(LDFLAGS_PCRE2) clp.o -o $(TEST_ELF)

.PHONY: tests

tests: $(TEST_ELF)
	./$(TEST_ELF)

install: $(ELF)
	@echo installing executable files to ${DESTDIR}${PREFIX}/bin
	@mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f clp ${DESTDIR}${PREFIX}/bin && \
	chmod 755 ${DESTDIR}${PREFIX}/bin/clp;
	echo installing support files to ${DESTDIR}${SHAREPREFIX}/clp; \
	mkdir -p ${DESTDIR}${SHAREPREFIX}/clp; \
	cp -r lua/* ${DESTDIR}${SHAREPREFIX}/clp;
	@echo installing manual pages to ${DESTDIR}${MANPREFIX}/man1
	@mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed -e "s/VERSION/${VERSION}/" < "man/clp.1" > \
	"${DESTDIR}${MANPREFIX}/man1/clp.1" && \
	chmod 644 "${DESTDIR}${MANPREFIX}/man1/clp.1"; \

uninstall:
	@echo removing executable file from ${DESTDIR}${PREFIX}/bin
	@rm -f ${DESTDIR}${PREFIX}/bin/clp
	@echo removing manual pages from ${DESTDIR}${MANPREFIX}/man1
	@rm -f ${DESTDIR}${MANPREFIX}/man1/clp.1
	@echo removing support files from ${DESTDIR}${SHAREPREFIX}/clp
	@rm -rf ${DESTDIR}${SHAREPREFIX}/clp

clean:
	rm -f clp $(TEST_ELF) *.o

clp.o: clp.c
	$(CC) -c clp.c $(CFLAGS) -o clp.o
