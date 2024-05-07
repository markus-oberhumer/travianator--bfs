# Copyright © Tavian Barnes <tavianator@tavianator.com>
# SPDX-License-Identifier: 0BSD

# Makefile that generates gen/config.h

include build/prelude.mk
include gen/config.mk
include build/exports.mk

# All header fragments we generate
HEADERS := \
    gen/has/acl-get-entry.h \
    gen/has/acl-get-file.h \
    gen/has/acl-get-tag-type.h \
    gen/has/acl-is-trivial-np.h \
    gen/has/acl-trivial.h \
    gen/has/aligned-alloc.h \
    gen/has/confstr.h \
    gen/has/extattr-get-file.h \
    gen/has/extattr-get-link.h \
    gen/has/extattr-list-file.h \
    gen/has/extattr-list-link.h \
    gen/has/fdclosedir.h \
    gen/has/getdents.h \
    gen/has/getdents64.h \
    gen/has/getdents64-syscall.h \
    gen/has/getmntent-1.h \
    gen/has/getmntent-2.h \
    gen/has/getmntinfo.h \
    gen/has/getprogname.h \
    gen/has/getprogname-gnu.h \
    gen/has/max-align-t.h \
    gen/has/pipe2.h \
    gen/has/posix-spawn-addfchdir.h \
    gen/has/posix-spawn-addfchdir-np.h \
    gen/has/st-acmtim.h \
    gen/has/st-acmtimespec.h \
    gen/has/st-birthtim.h \
    gen/has/st-birthtimespec.h \
    gen/has/st-flags.h \
    gen/has/statx.h \
    gen/has/statx-syscall.h \
    gen/has/strerror-l.h \
    gen/has/strerror-r-gnu.h \
    gen/has/strerror-r-posix.h \
    gen/has/string-to-flags.h \
    gen/has/strtofflags.h \
    gen/has/timegm.h \
    gen/has/tm-gmtoff.h \
    gen/has/uselocale.h

# Previously generated by pkgs.mk
PKG_HEADERS := ${ALL_PKGS:%=gen/use/%.h}

gen/config.h: ${PKG_HEADERS} ${HEADERS}
	${MSG} "[ GEN] $@"
	@printf '// %s\n' "$@" >$@
	@printf '#ifndef BFS_CONFIG_H\n' >>$@
	@printf '#define BFS_CONFIG_H\n' >>$@
	@cat ${.ALLSRC} >>$@
	@printf '#endif // BFS_CONFIG_H\n' >>$@
	@cat ${.ALLSRC:%=%.log} >gen/config.log
	${VCAT} $@
.PHONY: gen/config.h

# The short name of the config test
SLUG = ${@:gen/%.h=%}

${HEADERS}::
	@${MKDIR} ${@D}
	@build/define-if.sh ${SLUG} build/cc.sh build/${SLUG}.c >$@ 2>$@.log; \
	    build/msg-if.sh "[ CC ] ${SLUG}.c" test $$? -eq 0
