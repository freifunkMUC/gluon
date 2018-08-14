all:

LC_ALL:=C
LANG:=C
export LC_ALL LANG

<<<<<<< HEAD
export SHELL:=/usr/bin/env bash

GLUONPATH ?= $(PATH)
export GLUONPATH := $(GLUONPATH)

empty:=
space:= $(empty) $(empty)

GLUONMAKE_EARLY = PATH=$(GLUONPATH) $(SUBMAKE) -C $(GLUON_ORIGOPENWRTDIR) -f $(GLUONDIR)/Makefile GLUON_TOOLS=0 QUILT=
GLUONMAKE = PATH=$(GLUONPATH) $(SUBMAKE) -C $(GLUON_OPENWRTDIR) -f $(GLUONDIR)/Makefile
=======

# initialize (possibly already user set) directory variables
GLUON_SITEDIR ?= site
GLUON_TMPDIR ?= tmp
GLUON_OUTPUTDIR ?= output
>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159

GLUON_IMAGEDIR ?= $(GLUON_OUTPUTDIR)/images
GLUON_PACKAGEDIR ?= $(GLUON_OUTPUTDIR)/packages

<<<<<<< HEAD
GLUONDIR:=${CURDIR}

include $(GLUONDIR)/include/gluon.mk

TOPDIR:=$(GLUON_ORIGOPENWRTDIR)
export TOPDIR


update: FORCE
	$(GLUONDIR)/scripts/update.sh
	$(GLUONDIR)/scripts/patch.sh

update-patches: FORCE
	$(GLUONDIR)/scripts/update.sh
	$(GLUONDIR)/scripts/update-patches.sh
	$(GLUONDIR)/scripts/patch.sh

-include $(TOPDIR)/include/host.mk

_SINGLE=export MAKEFLAGS=$(space);

override OPENWRT_BUILD=1
override GLUON_TOOLS=1
GREP_OPTIONS=
export OPENWRT_BUILD GLUON_TOOLS GREP_OPTIONS
=======
# check for spaces & resolve possibly relative paths
define mkabspath
 ifneq (1,$(words [$($(1))]))
  $$(error $(1) must not contain spaces)
 endif
 override $(1) := $(abspath $($(1)))
endef
>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159

$(eval $(call mkabspath,GLUON_SITEDIR))
$(eval $(call mkabspath,GLUON_TMPDIR))
$(eval $(call mkabspath,GLUON_OUTPUTDIR))
$(eval $(call mkabspath,GLUON_IMAGEDIR))
$(eval $(call mkabspath,GLUON_PACKAGEDIR))

export GLUON_TMPDIR GLUON_IMAGEDIR GLUON_PACKAGEDIR DEVICES


$(GLUON_SITEDIR)/site.mk:
	$(error No site configuration was found. Please check out a site configuration to $(GLUON_SITEDIR))

include $(GLUON_SITEDIR)/site.mk

GLUON_RELEASE ?= $(error GLUON_RELEASE not set. GLUON_RELEASE can be set in site.mk or on the command line)

GLUON_MULTIDOMAIN ?= 0
GLUON_WLAN_MESH ?= 11s
GLUON_DEBUG ?= 0

export GLUON_RELEASE GLUON_REGION GLUON_MULTIDOMAIN GLUON_WLAN_MESH GLUON_DEBUG

show-release:
	@echo '$(GLUON_RELEASE)'


update: FORCE
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/update.sh
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/patch.sh
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/feeds.sh

update-patches: FORCE
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/update.sh
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/update-patches.sh
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/patch.sh

update-feeds: FORCE
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/feeds.sh


GLUON_TARGETS :=

define GluonTarget
gluon_target := $(1)$$(if $(2),-$(2))
GLUON_TARGETS += $$(gluon_target)
GLUON_TARGET_$$(gluon_target)_BOARD := $(1)
GLUON_TARGET_$$(gluon_target)_SUBTARGET := $(if $(3),$(3),$(2))
endef

include targets/targets.mk


LEDEMAKE = $(MAKE) -C lede

BOARD := $(GLUON_TARGET_$(GLUON_TARGET)_BOARD)
SUBTARGET := $(GLUON_TARGET_$(GLUON_TARGET)_SUBTARGET)

GLUON_CONFIG_VARS := \
	GLUON_SITEDIR='$(GLUON_SITEDIR)' \
	GLUON_RELEASE='$(GLUON_RELEASE)' \
	GLUON_BRANCH='$(GLUON_BRANCH)' \
	GLUON_LANGS='$(GLUON_LANGS)' \
	BOARD='$(BOARD)' \
	SUBTARGET='$(SUBTARGET)'

LEDE_TARGET := $(BOARD)$(if $(SUBTARGET),-$(SUBTARGET))

export LEDE_TARGET


CheckTarget := [ '$(LEDE_TARGET)' ] \
	|| (echo 'Please set GLUON_TARGET to a valid target. Gluon supports the following targets:'; $(foreach target,$(GLUON_TARGETS),echo ' * $(target)';) false)

CheckExternal := test -d lede || (echo 'You don'"'"'t seem to have obtained the external repositories needed by Gluon; please call `make update` first!'; false)

define CheckSite
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' GLUON_SITE_CONFIG='$(1).conf' $(LUA) scripts/site_config.lua \
		|| (echo 'Your site configuration ($(1).conf) did not pass validation.'; false)

endef

list-targets: FORCE
	@$(foreach target,$(GLUON_TARGETS),echo '$(target)';)


GLUON_FEATURE_PACKAGES := $(shell scripts/features.sh '$(GLUON_FEATURES)' || echo '__ERROR__')
ifneq ($(filter __ERROR__,$(GLUON_FEATURE_PACKAGES)),)
$(error Error while evaluating GLUON_FEATURES)
endif


GLUON_PACKAGES :=
define merge_packages
  $(foreach pkg,$(1),
    GLUON_PACKAGES := $$(strip $$(filter-out -$$(patsubst -%,%,$(pkg)) $$(patsubst -%,%,$(pkg)),$$(GLUON_PACKAGES)) $(pkg))
  )
endef
<<<<<<< HEAD


export SHA512SUM := $(GLUONDIR)/scripts/sha512sum.sh


prereq: FORCE
	+$(NO_TRACE_MAKE) prereq

prepare-tmpinfo: FORCE
	@+$(MAKE) -r -s staging_dir/host/.prereq-build OPENWRT_BUILD= QUIET=0
	mkdir -p tmp/info
	$(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="packageinfo" SCAN_DIR="package" SCAN_NAME="package" SCAN_DEPS="$(TOPDIR)/include/package*.mk $(TOPDIR)/overlay/*/*.mk" SCAN_EXTRA=""
	$(_SINGLE)$(NO_TRACE_MAKE) -j1 -r -s -f include/scan.mk SCAN_TARGET="targetinfo" SCAN_DIR="target/linux" SCAN_NAME="target" SCAN_DEPS="profiles/*.mk $(TOPDIR)/include/kernel*.mk $(TOPDIR)/include/target.mk" SCAN_DEPTH=2 SCAN_EXTRA="" SCAN_MAKEOPTS="TARGET_BUILD=1"
	for type in package target; do \
		f=tmp/.$${type}info; t=tmp/.config-$${type}.in; \
		[ "$$t" -nt "$$f" ] || ./scripts/metadata.pl $${type}_config "$$f" > "$$t" || { rm -f "$$t"; echo "Failed to build $$t"; false; break; }; \
	done
	[ tmp/.config-feeds.in -nt tmp/.packagefeeds ] || ./scripts/feeds feed_config > tmp/.config-feeds.in
	./scripts/metadata.pl package_mk tmp/.packageinfo > tmp/.packagedeps || { rm -f tmp/.packagedeps; false; }
	./scripts/metadata.pl package_feeds tmp/.packageinfo > tmp/.packagefeeds || { rm -f tmp/.packagefeeds; false; }
	touch $(TOPDIR)/tmp/.build

feeds: FORCE
	rm -rf $(TOPDIR)/package/feeds
	mkdir $(TOPDIR)/package/feeds
	[ ! -f $(GLUON_SITEDIR)/modules ] || . $(GLUON_SITEDIR)/modules && for feed in $$GLUON_SITE_FEEDS; do ln -s ../../../packages/$$feed $(TOPDIR)/package/feeds/$$feed; done
	ln -s ../../../package $(TOPDIR)/package/feeds/gluon
	. $(GLUONDIR)/modules && for feed in $$GLUON_FEEDS; do ln -s ../../../packages/$$feed $(TOPDIR)/package/feeds/module_$$feed; done
	+$(GLUONMAKE_EARLY) prepare-tmpinfo

gluon-tools: FORCE
	+$(GLUONMAKE_EARLY) tools/patch/install
	+$(GLUONMAKE_EARLY) tools/sed/install
	+$(GLUONMAKE_EARLY) tools/cmake/install
	+$(GLUONMAKE_EARLY) package/lua/host/install package/usign/host/install



early_prepared_stamp := $(GLUON_BUILDDIR)/prepared_$(shell \
	( \
		$(SHA512SUM) $(GLUONDIR)/modules; \
		[ ! -r $(GLUON_SITEDIR)/modules ] || $(SHA512SUM) $(GLUON_SITEDIR)/modules \
	) | $(SHA512SUM) )

prepare-early: FORCE
	for dir in build_dir dl staging_dir; do \
		mkdir -p $(GLUON_ORIGOPENWRTDIR)/$$dir; \
	done

	+$(GLUONMAKE_EARLY) feeds
	+$(GLUONMAKE_EARLY) gluon-tools

	mkdir -p $$(dirname $(early_prepared_stamp))
	touch $(early_prepared_stamp)

$(early_prepared_stamp):
	rm -f $(GLUON_BUILDDIR)/prepared_*
	+$(GLUONMAKE_EARLY) prepare-early

$(GLUON_OPKG_KEY): $(early_prepared_stamp) FORCE
	[ -s $(GLUON_OPKG_KEY) -a -s $(GLUON_OPKG_KEY).pub ] || \
		( mkdir -p $$(dirname $(GLUON_OPKG_KEY)) && $(STAGING_DIR_HOST)/bin/usign -G -s $(GLUON_OPKG_KEY) -p $(GLUON_OPKG_KEY).pub -c "Gluon opkg key" )

$(GLUON_OPKG_KEY).pub: $(GLUON_OPKG_KEY)

create-key: $(GLUON_OPKG_KEY).pub

include $(GLUONDIR)/targets/targets.mk

ifneq ($(GLUON_TARGET),)

include $(GLUONDIR)/targets/$(GLUON_TARGET)/profiles.mk

BOARD := $(GLUON_TARGET_$(GLUON_TARGET)_BOARD)
override SUBTARGET := $(GLUON_TARGET_$(GLUON_TARGET)_SUBTARGET)

target_prepared_stamp := $(BOARD_BUILDDIR)/target-prepared
gluon_prepared_stamp := $(BOARD_BUILDDIR)/prepared

PREPARED_RELEASE = $$(cat $(gluon_prepared_stamp))
IMAGE_PREFIX = gluon-$(GLUON_SITE_CODE)-$(PREPARED_RELEASE)
MODULE_PREFIX = gluon-$(GLUON_SITE_CODE)-$(PREPARED_RELEASE)


include $(INCLUDE_DIR)/target.mk

build-key: FORCE
	rm -f $(BUILD_KEY) $(BUILD_KEY).pub
	cp $(GLUON_OPKG_KEY) $(BUILD_KEY)
	cp $(GLUON_OPKG_KEY).pub $(BUILD_KEY).pub

config: FORCE
	+$(NO_TRACE_MAKE) scripts/config/conf OPENWRT_BUILD= QUIET=0
	+$(GLUONMAKE) prepare-tmpinfo
	( \
		cat $(GLUONDIR)/include/config; \
		echo 'CONFIG_TARGET_$(GLUON_TARGET_$(GLUON_TARGET)_BOARD)=y'; \
		$(if $(GLUON_TARGET_$(GLUON_TARGET)_SUBTARGET), \
			echo 'CONFIG_TARGET_$(GLUON_TARGET_$(GLUON_TARGET)_BOARD)_$(GLUON_TARGET_$(GLUON_TARGET)_SUBTARGET)=y'; \
		) \
		cat $(GLUONDIR)/targets/$(GLUON_TARGET)/config 2>/dev/null; \
		echo 'CONFIG_BUILD_SUFFIX="gluon-$(GLUON_TARGET)"'; \
		echo '$(patsubst %,CONFIG_PACKAGE_%=m,$(sort $(filter-out -%,$(GLUON_DEFAULT_PACKAGES) $(GLUON_SITE_PACKAGES) $(PROFILE_PACKAGES))))' \
			| sed -e 's/ /\n/g'; \
		echo '$(patsubst %,CONFIG_LUCI_LANG_%=y,$(GLUON_LANGS))' \
			| sed -e 's/ /\n/g'; \
	) > $(BOARD_BUILDDIR)/config.tmp
	scripts/config/conf --defconfig=$(BOARD_BUILDDIR)/config.tmp Config.in
	+$(SUBMAKE) tools/install

prepare-target: $(GLUON_OPKG_KEY).pub
	rm $(GLUON_OPENWRTDIR)/tmp || true
	mkdir -p $(GLUON_OPENWRTDIR)/tmp

	for link in build_dir config Config.in dl include Makefile package rules.mk scripts staging_dir target toolchain tools; do \
		ln -sf $(GLUON_ORIGOPENWRTDIR)/$$link $(GLUON_OPENWRTDIR); \
	done

	+$(GLUONMAKE) config
	touch $(target_prepared_stamp)

$(target_prepared_stamp):
	+$(GLUONMAKE_EARLY) prepare-target

maybe-prepare-target: $(target_prepared_stamp)
	+$(GLUONMAKE_EARLY) $(GLUON_OPKG_KEY).pub

$(BUILD_DIR)/.prepared: Makefile
	@mkdir -p $$(dirname $@)
	@touch $@

$(toolchain/stamp-install): $(tools/stamp-install)
$(package/stamp-compile): $(package/stamp-cleanup)


clean: FORCE
	+$(SUBMAKE) clean
	rm -f $(gluon_prepared_stamp)


download: FORCE
	+$(SUBMAKE) tools/download
	+$(SUBMAKE) toolchain/download
	+$(SUBMAKE) package/download
	+$(SUBMAKE) target/download

toolchain: $(toolchain/stamp-install) $(tools/stamp-install)

include $(INCLUDE_DIR)/kernel.mk

kernel: FORCE
	+$(NO_TRACE_MAKE) -C $(TOPDIR)/target/linux/$(BOARD) $(LINUX_DIR)/.image TARGET_BUILD=1
	+$(NO_TRACE_MAKE) -C $(TOPDIR)/target/linux/$(BOARD) $(LINUX_DIR)/.modules TARGET_BUILD=1

packages: $(package/stamp-compile)
	$(_SINGLE)$(SUBMAKE) -r package/index

prepare-image: FORCE
	rm -rf $(BOARD_KDIR)
	mkdir -p $(BOARD_KDIR)
	-cp $(KERNEL_BUILD_DIR)/* $(BOARD_KDIR)/
	+$(SUBMAKE) -C $(TOPDIR)/target/linux/$(BOARD)/image image_prepare KDIR="$(BOARD_KDIR)"

prepare: FORCE
	@$(STAGING_DIR_HOST)/bin/lua $(GLUONDIR)/scripts/site_config.lua \
		|| (echo 'Your site configuration did not pass validation.'; false)

	mkdir -p $(GLUON_IMAGEDIR) $(BOARD_BUILDDIR)
	echo 'src packages file:../openwrt/bin/$(BOARD)/packages' > $(BOARD_BUILDDIR)/opkg.conf

	+$(GLUONMAKE) toolchain
	+$(GLUONMAKE) kernel
	+$(GLUONMAKE) packages
	+$(GLUONMAKE) prepare-image
=======
$(eval $(call merge_packages,$(GLUON_FEATURE_PACKAGES) $(GLUON_SITE_PACKAGES)))

config: FORCE
	@$(CheckExternal)
	@$(CheckTarget)
>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159

	@$(GLUON_CONFIG_VARS) \
		scripts/target_config.sh '$(GLUON_TARGET)' '$(GLUON_PACKAGES)' \
		> lede/.config
	+@$(LEDEMAKE) defconfig

	@$(GLUON_CONFIG_VARS) \
		scripts/target_config_check.sh '$(GLUON_TARGET)' '$(GLUON_PACKAGES)'


LUA := lede/staging_dir/hostpkg/bin/lua

$(LUA):
	@$(CheckExternal)

	+@[ -e lede/.config ] || $(LEDEMAKE) defconfig
	+@$(LEDEMAKE) tools/install
	+@$(LEDEMAKE) package/lua/host/install

prepare-target: config $(LUA) ;

all: prepare-target
	$(foreach conf,site $(patsubst $(GLUON_SITEDIR)/%.conf,%,$(wildcard $(GLUON_SITEDIR)/domains/*.conf)),$(call CheckSite,$(conf)))

	@scripts/clean_output.sh
	+@$(LEDEMAKE)
	@GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/copy_output.sh '$(GLUON_TARGET)'

clean download: config
	+@$(LEDEMAKE) $@

dirclean: FORCE
	+@[ -e lede/.config ] || $(LEDEMAKE) defconfig
	+@$(LEDEMAKE) dirclean
	@rm -rf $(GLUON_TMPDIR) $(GLUON_OUTPUTDIR)

manifest: $(LUA) FORCE
	@[ '$(GLUON_BRANCH)' ] || (echo 'Please set GLUON_BRANCH to create a manifest.'; false)
	@echo '$(GLUON_PRIORITY)' | grep -qE '^([0-9]*\.)?[0-9]+$$' || (echo 'Please specify a numeric value for GLUON_PRIORITY to create a manifest.'; false)
	@$(CheckExternal)

	@( \
		echo 'BRANCH=$(GLUON_BRANCH)' && \
		echo "DATE=$$($(LUA) scripts/rfc3339date.lua)" && \
		echo 'PRIORITY=$(GLUON_PRIORITY)' && \
		echo && \
		$(foreach GLUON_TARGET,$(GLUON_TARGETS), \
			GLUON_SITEDIR='$(GLUON_SITEDIR)' scripts/generate_manifest.sh '$(GLUON_TARGET)' && \
		) : \
	) > 'tmp/$(GLUON_BRANCH).manifest.tmp'

	@mkdir -p '$(GLUON_IMAGEDIR)/sysupgrade'
	@mv 'tmp/$(GLUON_BRANCH).manifest.tmp' '$(GLUON_IMAGEDIR)/sysupgrade/$(GLUON_BRANCH).manifest'

FORCE: ;

.PHONY: FORCE
.NOTPARALLEL:
