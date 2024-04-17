# Copyright © Tavian Barnes <tavianator@tavianator.com>
# SPDX-License-Identifier: 0BSD

# Makefile fragment that implements `make config`

include config/prelude.mk
include config/exports.mk

# Makefile fragments generated by `make config`
MKS := \
    ${GEN}/vars.mk \
    ${GEN}/flags.mk \
    ${GEN}/deps.mk \
    ${GEN}/objs.mk \
    ${GEN}/pkgs.mk

# The main configuration file, which includes the others
${CONFIG}: ${MKS}
	${MSG} "[ GEN] $@"
	@printf '# %s\n' "$@" >$@
	@printf 'include $${GEN}/%s\n' ${.ALLSRC:${GEN}/%=%} >>$@
	${VCAT} ${CONFIG}
.PHONY: ${CONFIG}

# Saves the configurable variables
${GEN}/vars.mk::
	@${MKDIR} ${@D}
	${MSG} "[ GEN] $@"
	@printf '# %s\n' "$@" >$@
	@printf 'PREFIX := %s\n' "$$XPREFIX" >>$@
	@printf 'MANDIR := %s\n' "$$XMANDIR" >>$@
	@printf 'OS := %s\n' "$${OS:-$$(uname)}" >>$@
	@printf 'ARCH := %s\n' "$${ARCH:-$$(uname -m)}" >>$@
	@printf 'CC := %s\n' "$$XCC" >>$@
	@printf 'INSTALL := %s\n' "$$XINSTALL" >>$@
	@printf 'MKDIR := %s\n' "$$XMKDIR" >>$@
	@printf 'PKG_CONFIG := %s\n' "$$XPKG_CONFIG" >>$@
	@printf 'RM := %s\n' "$$XRM" >>$@
	@printf 'PKGS :=\n' >>$@
	${VCAT} $@

# Sets the build flags.  This depends on vars.mk and uses a recursive make so
# that the default flags can depend on variables like ${OS}.
${GEN}/flags.mk: ${GEN}/vars.mk
	@+${MAKE} -sf config/flags.mk
.PHONY: ${GEN}/flags.mk

# Check for dependency generation support
${GEN}/deps.mk: ${GEN}/flags.mk
	@+${MAKE} -sf config/deps.mk
.PHONY: ${GEN}/deps.mk

# Lists file.o: file.c dependencies
${GEN}/objs.mk::
	@${MKDIR} ${@D}
	${MSG} "[ GEN] $@"
	@printf '# %s\n' "$@" >$@
	@for obj in ${OBJS:${OBJ}/%.o=%}; do printf '$${OBJ}/%s.o: %s.c\n' "$$obj" "$$obj"; done >>$@

# External dependencies
PKG_MKS := \
    ${GEN}/libacl.mk \
    ${GEN}/libcap.mk \
    ${GEN}/libselinux.mk \
    ${GEN}/liburing.mk \
    ${GEN}/oniguruma.mk

# Auto-detect dependencies and their build flags
${GEN}/pkgs.mk: ${PKG_MKS}
	@printf '# %s\n' "$@" >$@
	@printf 'include $${GEN}/%s\n' ${.ALLSRC:${GEN}/%=%} >>$@
	@+${MAKE} -sf config/pkgs.mk
.PHONY: ${GEN}/pkgs.mk

# Auto-detect dependencies
${PKG_MKS}: ${GEN}/flags.mk
	@+${MAKE} -sf config/pkg.mk TARGET=$@
.PHONY: ${PKG_MKS}
