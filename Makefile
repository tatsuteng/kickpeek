#
# Copyright (C) 2016 KickPeek
# Copyright (C) 2016 KickPeek Author <tatsuteng@gmail.com>
#
# This is free software, licensed under the GNU General Public License v3.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=kickpeek
PKG_VERSION:=0.1
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Tatsuteng <tatsuteng@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	PKGARCH:=all
	TITLE:=KickPeek
	URL:=https://github.com/tatsuteng/kickpeek
	DEPENDS:=+iw +hostapd-utils +lua
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/description
      	Kick WiFi peeker
endef

define Package/$(PKG_NAME)/conffiles
/etc/config/kickpeek
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/kickpeek.lua $(1)/usr/bin/kickpeek
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/kickpeek.init $(1)/etc/init.d/kickpeek
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/kickpeek.config $(1)/etc/config/kickpeek
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
