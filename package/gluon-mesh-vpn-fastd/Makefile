include $(TOPDIR)/rules.mk

PKG_NAME:=gluon-mesh-vpn-fastd
PKG_VERSION:=3

include ../gluon.mk

define Package/gluon-mesh-vpn-fastd
<<<<<<< HEAD
  SECTION:=gluon
  CATEGORY:=Gluon
  TITLE:=Support for connecting batman-adv meshes via fastd
  DEPENDS:=+gluon-core +libgluonutil gluon-mesh-batman-adv +gluon-wan-dnsmasq +fastd +iptables +iptables-mod-extra +simple-tc
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/gluon-mesh-vpn-fastd/install
	$(CP) ./files/* $(1)/

	$(INSTALL_DIR) $(1)/lib/gluon/respondd
	$(CP) $(PKG_BUILD_DIR)/respondd.so $(1)/lib/gluon/respondd/mesh-vpn-fastd.so
endef

define Package/gluon-mesh-vpn-fastd/postinst
#!/bin/sh
$(call GluonCheckSite,check_site.lua)
=======
  TITLE:=Support for connecting meshes via fastd
  DEPENDS:=+gluon-core +libgluonutil +gluon-mesh-vpn-core +fastd +@GLUON_SPECIALIZE_KERNEL:KERNEL_TUN
>>>>>>> 6a3d5554c170da07c3c5be3741ab9921e5839159
endef

$(eval $(call BuildPackageGluon,gluon-mesh-vpn-fastd))
