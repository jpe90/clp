-include config.mk

CFLAGS             += -Wall -pedantic
CFLAGS 			   += -I $(CURDIR)/include
CFLAGS             += $(CFLAGS_LUA)
CFLAGS             += $(CFLAGS_AUTO)
CFLAGS             +=  -DCLP_PATH=\"${SHAREPREFIX}/clp\"
LDFLAGS             = $(LDFLAGS_LUA)
LDFLAGS            += $(LDFLAGS_AUTO)
SRC                 = clp.c
ELF                 = clp

ALL: $(ELF)

config.mk:
	@touch $@

clp: config.mk clp.c
	$(CC) $(SRC) $(CFLAGS) $(LDFLAGS) -o clp

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
	rm clp
